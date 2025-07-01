# This module acts as a factory for creating NixOS containers declaratively.
# It reads a list of service definitions and generates:
# 1. The full configuration for each container.
# 2. Port forwarding from the host to the container.
# 3. Firewall rules on the host to allow traffic to the containers.
{ config, lib, pkgs, ... }:

with lib;

let
  # Get the custom options defined below.
  cfg = config.services.containerFactory;

  # This function takes a container definition list and transforms it
  # into a full NixOS container configuration attribute set.
  buildContainer = containerList:
    let
      # Extract values from the list format: [ name service port extraArgs ]
      name = elemAt containerList 0;
      service = elemAt containerList 1;
      port = elemAt containerList 2;
      extraArgs = if length containerList > 3 then elemAt containerList 3 else {};

      # --- Input Validation ---
      # Ensure the list has at least 3 elements
      listLength = length containerList;
    in
    if listLength < 3 then throw "Container list must have at least 3 elements: [ name service port extraArgs ]"
    else if !isString name then throw "Container name must be a string, got: ${toString name}"
    else if !isString service then throw "Container service must be a string, got: ${toString service}"
    else if !isInt port then throw "Container port must be an integer, got: ${toString port}"
    else if listLength > 3 && !isAttrs extraArgs then throw "Container extraArgs must be an attribute set, got: ${toString extraArgs}"
    else
      # --- Configuration Generation ---
      nameValuePair name {
        # Start this container automatically on boot.
        autoStart = true;

        # Use a private network for communication between the host and container.
        privateNetwork = true;

        # We generate a unique IP address for each container based on its port
        # to avoid collisions. This is a simple but effective trick.
        hostAddress = "10.233.${toString (mod port 254 + 1)}.1";
        localAddress = "10.233.${toString (mod port 254 + 1)}.2";

        # Forward the specified port from the host to the same port inside the container.
        forwardPorts = [
          { hostPort = port; containerPort = port; }
        ];

        # This is the actual NixOS configuration for the system running *inside* the container.
        # We pass the container definition data down to the container's modules
        # so they can access things like the port number and extra arguments.
        specialArgs = {
          containerDef = {
            inherit name service;
            hostPort = port;
          } // extraArgs;
        };

        config = {
          # Import the specific service module for this container.
          # The path is constructed from the service attribute (e.g., "suwayomi" -> ./services/suwayomi.nix).
          imports = [ (./. + "/services/${service}.nix") ];

          # Basic container configuration.
          system.stateVersion = config.system.stateVersion;

          # Disable the container's own firewall, as the host manages access.
          networking.firewall.enable = false;

          # Allow logging in as root without a password for easy debugging.
          # Use nixos-container login <name> to get a shell.
          users.users.root.initialHashedPassword = "";

          # Allow unfree packages if needed by the service within the container.
          nixpkgs.config.allowUnfree = true;
        } // extraArgs; # Merge extraArgs into the container config
      };

  buildNginxHost = containerList:
    let
      name = elemAt containerList 0;
      port = elemAt containerList 2;
      domain = "${name}.${cfg.domainSuffix}";
    in
    nameValuePair domain {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://localhost:${toString port}";
        proxyWebsockets = true;
      };
    };

in {
  # --- Custom Options ---
  # We define a new set of options under services.containerFactory to make the configuration clean.
  options.services.containerFactory = {
    enable = mkEnableOption "declarative NixOS container factory";

    containersList = mkOption {
      type = types.listOf (types.listOf types.anything);
      default = [];
      description = ''
        A list of lists defining the containers to be built.
        Each list should have the format: [ name service port extraArgs ]
      '';
      example = literalExample ''
        [
          [ "paperless" "paperless" 8080 { services.paperless.dataDir = "/var/lib/paperless"; } ]
          [ "mealie" "mealie" 9090 ]
        ]
      '';
    };

    domainSuffix = mkOption {
      type = types.str;
      default = "example.com";
      description = "Suffix used to generate subdomains (e.g. paperless.example.com)";
    };
  };

  # --- System Configuration ---
  # This section applies the generated configurations to your actual system.
  config = mkIf cfg.enable {
    # Generate the containers attribute set by mapping our build function
    # over the user-provided list and converting the result to an attribute set.
    containers = listToAttrs (map buildContainer cfg.containersList);

    services.nginx = {
      enable = true;
      virtualHosts = listToAttrs (map buildNginxHost cfg.containersList);
    };

    security.acme = {
      acceptTerms = true;
      email = "Credible3736@byom.de"; # Set your real email
    };

    networking.firewall.allowedTCPPorts =
      [ 80 443 ] ++ map (c: elemAt c 2) cfg.containersList;
  };
}
