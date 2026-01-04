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
    ./modules/printer.nix
    ./modules/desktop.nix

    # optional modules
    ./modules/programs.nix
    ./modules/spicetify.nix

    #tailscale client
    ./services/tailscale-client.nix

  ];
  
  # Base system config
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config = {
    allowUnfree = true;
    allowInsecure = true;
    allowBroken = true;
  };

  system.stateVersion = "25.11";
}
