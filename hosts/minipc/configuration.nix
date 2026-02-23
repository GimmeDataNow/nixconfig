{ pkgs, unstable, inputs, lib, user, ... }: {
  imports = [
    ./hardware.nix

    # Core System Modules
    ../../modules/nixos/common/boot.nix
    ../../modules/nixos/common/common.nix
    ../../modules/nixos/common/location.nix
    
    # Home Manager (Just for Shell/CLI tools)
    inputs.home-manager.nixosModules.home-manager
  ];

  # --- SERVER SPECIFIC SETTINGS ---
  
  # SSH Setup (Password based as requested)
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.PermitRootLogin = "no";
  };
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Docker Setup
  virtualisation.docker.enable = true;
  users.users.${user}.extraGroups = [ "docker" ];

  # Hostname
  networking.hostName = "minipc";

  # --- HOME MANAGER (CLI ONLY) ---
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs unstable user; };
    backupFileExtension = "bak";
    users.${user} = {
      imports = [
        ../../modules/home/shell.nix # Keep your aliases and bash settings!
      ];
      home.stateVersion = "25.11";
    };
  };

  # --- SYSTEM CONFIG ---
  time.timeZone = lib.mkForce null; # Let location.nix/geoclue handle it
  boot.kernelPackages = unstable.linuxPackages_latest;
  system.stateVersion = "25.11"; 
}
