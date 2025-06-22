{ ... }: {

  imports = [
    # essential modules
    ./modules/hardware.nix
    ./modules/boot.nix
    ./modules/users.nix
    ./modules/time_locale.nix
    ./modules/networking.nix
    ./modules/security.nix
    ./modules/sound.nix
    ./modules/fonts.nix
    ./modules/environment.nix

    # optional modules
    ./modules/programs.nix

    # services
    ./services/suwayomi.nix
  ];
  
  # Base system config
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config = {
    allowUnfree = true;
    allowInsecure = true;
    allowBroken = true;
  };

  system.stateVersion = "25.05";
}
