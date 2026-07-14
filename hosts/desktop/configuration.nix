{ pkgs, unstable, inputs, lib, user, ... }: {
  imports = [
    # 1. Physical Hardware scan (Specific to this machine)
    ./hardware.nix

    # 2. Reusable NixOS Modules (We will create these next)
    ../../modules/nixos/common/boot.nix
    ../../modules/nixos/common/common.nix      # Core settings for all machines
    ../../modules/nixos/common/location.nix    # Allows for the time to automatically update based on location
    ../../modules/nixos/desktop/networking.nix
    ../../modules/nixos/desktop/gpu-amd.nix
    ../../modules/nixos/desktop/hyprland.nix
    ../../modules/nixos/desktop/fonts.nix
    ../../modules/nixos/desktop/programs/cli.nix
    ../../modules/nixos/desktop/programs/communication.nix
    ../../modules/nixos/desktop/programs/gaming.nix
    ../../modules/nixos/desktop/programs/gui.nix
    ../../modules/nixos/desktop/audio.nix
    ../../modules/nixos/desktop/tailscale-client.nix
    # ../../modules/nixos/desktop/ollama.nix
    ../../modules/nixos/common/surrealdb.nix
    # ../../modules/nixos/desktop/backlight.nix
    
    # 3. Home Manager Integration (The "Dotfiles" engine)
    inputs.home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = { inherit inputs unstable user; };
      home-manager.backupFileExtension = "bak";
      home-manager.users.${user} = {
        imports = [
          ../../modules/home/shell.nix
          ../../modules/home/starship.nix
          ../../modules/home/kitty.nix
          ../../modules/home/helix.nix
          ../../modules/home/nnn.nix

          ../../modules/home/desktop.nix
          ../../modules/home/wayland.nix
          ../../modules/home/hyprland/default.nix
          ../../modules/home/xdg-settings.nix
          ../../modules/home/spicetify.nix
          ../../modules/home/waybar.nix
          # ../../modules/home/zed.nix
        ];

        wayland.windowManager.hyprland.settings = {
          monitor = [
            ", preferred, auto, 1"
          ];
        };
      };

    }
  ];

  # This override ensures geoclue takes precedence over the "UTC" default
  time.timeZone = lib.mkForce null;

  # Autologin
  services.getty.autologinUser = "${user}";

  # Host-specific networking
  networking.hostName = "desktop";

  # Example: Using 'unstable' for a specific system-level package
  boot.kernelPackages = unstable.linuxPackages_latest;

  system.stateVersion = "26.05"; 
}
