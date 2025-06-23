{ lib, ... }:

{
  # Generic container creation function
  makeContainer = name: containerPort: hostPort: {
    containers.${name} = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.${toString (11 + (lib.strings.stringLength name))}"; # unique IP per container
      
      config = { config, pkgs, ... }: {
        system.stateVersion = "25.05";
        
        networking.firewall.allowedTCPPorts = [ containerPort ];
        
        # Container-specific services - same as writing in default.nix
        services = lib.mkMerge [
          # Webserver container
          (lib.mkIf (name == "webserver") {
            nginx = {
              enable = true;
              virtualHosts.default = {
                listen = [{ addr = "0.0.0.0"; port = containerPort; }];
                locations."/" = {
                  return = "200 'Hello from ${name} container on port ${toString containerPort}!'";
                  extraConfig = "add_header Content-Type text/plain;";
                };
              };
            };
          })
          
          # SSH server container - uses host user configuration
          (lib.mkIf (name == "sshserver") {
            openssh = {
              enable = true;
              ports = [ containerPort ];
              settings = {
                PasswordAuthentication = true;
                PermitRootLogin = "yes";
                AllowUsers = null;
                UseDns = true;
                X11Forwarding = false;
              };
            };
          })
        ];
        
        # Share host users with containers (like writing users.users in default.nix)
        users.mutableUsers = true;
      };
    };
    
    # Host networking configuration (ports managed in networking.nix)
    networking.nat = {
      enable = true;
      internalInterfaces = [ "ve-${name}" ];
      forwardPorts = [{
        sourcePort = hostPort;
        destination = "192.168.100.${toString (11 + (lib.strings.stringLength name))}:${toString containerPort}";
        proto = "tcp";
      }];
    };
  };
  
  # Immich container function
  makeImmichContainer = name: containerPort: hostPort: {
    containers.${name} = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.10";
      localAddress = "192.168.100.20";
      
      bindMounts = {
        "/var/lib/immich" = {
          hostPath = "/var/lib/containers/${name}/data";
          isReadOnly = false;
        };
        "/photos" = {
          hostPath = "/var/lib/containers/${name}/photos";
          isReadOnly = false;
        };
      };
      
      config = { config, pkgs, ... }: {
        system.stateVersion = "25.05";
        
        networking.firewall.allowedTCPPorts = [ containerPort ];
        
        # PostgreSQL for Immich - same as writing in default.nix
        services.postgresql = {
          enable = true;
          ensureDatabases = [ "immich" ];
          ensureUsers = [{
            name = "immich";
            ensureDBOwnership = true;
          }];
        };
        
        # Redis for Immich - same as writing in default.nix
        services.redis.servers.immich = {
          enable = true;
          port = 6379;
        };
        
        # Placeholder Immich service (since not in nixpkgs yet)
        systemd.services.immich-server = {
          description = "Immich Photo Server";
          after = [ "postgresql.service" "redis-immich.service" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "simple";
            User = "immich";
            Group = "immich";
            WorkingDirectory = "/var/lib/immich";
            ExecStart = "${pkgs.writeShellScript "immich-mock" ''
              echo "Immich server starting on port ${toString containerPort}"
              ${pkgs.python3}/bin/python -m http.server ${toString containerPort} --bind 0.0.0.0
            ''}";
            Restart = "always";
          };
        };
        
        # System users for services - same as writing in default.nix
        users.users.immich = {
          isSystemUser = true;
          group = "immich";
          home = "/var/lib/immich";
          createHome = true;
        };
        users.groups.immich = {};
        
        # Allow host users to access container
        users.mutableUsers = true;
      };
    };
    
    # Host configuration (ports managed in networking.nix)
    networking.nat = {
      enable = true;
      internalInterfaces = [ "ve-${name}" ];
      forwardPorts = [{
        sourcePort = hostPort;  
        destination = "192.168.100.20:${toString containerPort}";
        proto = "tcp";
      }];
    };
    
    # Create host directories
    systemd.tmpfiles.rules = [
      "d /var/lib/containers/${name} 0755 root root -"
      "d /var/lib/containers/${name}/data 0755 root root -"
      "d /var/lib/containers/${name}/photos 0755 root root -"
    ];
  };
}
