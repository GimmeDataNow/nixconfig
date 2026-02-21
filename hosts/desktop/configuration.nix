{ pkgs, unstable, inputs, user, ... }: {
  imports = [
    # 1. Physical Hardware scan (Specific to this machine)
    ./hardware.nix

    # 2. Reusable NixOS Modules (We will create these next)
    ../../modules/nixos/common/common.nix      # Core settings for all machines
    ../../modules/nixos/desktop/gui.nix # Specific to GUI machines (Nvidia, Audio)
    
    # 3. Home Manager Integration (The "Dotfiles" engine)
    inputs.home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit inputs unstable user; };
      home-manager.users.${user} = import ../../modules/home/desktop.nix;
    }
  ];

  # Autologin
  services.getty.autologinUser = "${user}";

  # Host-specific networking
  networking.hostName = "desktop";

  # Example: Using 'unstable' for a specific system-level package
  boot.kernelPackages = unstable.linuxPackages_latest;

  system.stateVersion = "25.11"; 
}
