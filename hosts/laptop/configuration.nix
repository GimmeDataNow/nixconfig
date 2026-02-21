{ pkgs, unstable, inputs, lib, user, ... }: {
  imports = [
    # 1. Physical Hardware scan (Specific to this machine)
    ./hardware.nix

    # 2. Reusable NixOS Modules (We will create these next)
    ../../modules/nixos/common/common.nix      # Core settings for all machines
    ../../modules/nixos/common/location.nix    # Allows for the time to automatically update based on location
    # ../../modules/nixos/desktop/gui.nix        # Specific to GUI machines (Nvidia, Audio)
    ../../modules/nixos/desktop/hyprland.nix
    ../../modules/nixos/desktop/gpu-amd.nix
    ../../modules/nixos/desktop/networking.nix
    ../../modules/nixos/desktop/fonts.nix
    ../../modules/nixos/desktop/programs-cli.nix
    ../../modules/nixos/desktop/programs-gui.nix
    ../../modules/nixos/common/boot.nix
    
    # 3. Home Manager Integration (The "Dotfiles" engine)
    inputs.home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit inputs unstable user; };
      home-manager.users.${user} = import ../../modules/home/desktop.nix;
    }
  ];

  # This override ensures geoclue takes precedence over the "UTC" default
  time.timeZone = lib.mkForce null;

  # Autologin
  services.getty.autologinUser = "${user}";

  # Host-specific networking
  networking.hostName = "laptop";

  # Example: Using 'unstable' for a specific system-level package
  boot.kernelPackages = unstable.linuxPackages_latest;

  system.stateVersion = "25.11"; 
}
