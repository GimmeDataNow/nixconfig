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

    # these services are mandatory and should not
    # be placed inside of the container factory
    ./services/ssh.nix
    ./services/docker.nix
    ./services/tailscale.nix

    # non vital services are made inside of this
    ./modules/container-factory.nix
  ];
  
  # Base system config
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config = {
    allowUnfree = true;
    allowInsecure = true;
    allowBroken = true;
  };

  system.stateVersion = "25.05";

   services.containerFactory = {
    enable = true;
    containersList = [
      ["immich-memes"  "immich"      2283]
      ["immich-art"    "immich"      2284]
      ["suwayomi"      "suwayomi"    4567]
      ["suwayomi-nsfw" "suwayomi"    4568]
      ["paperless"     "paperless"   8452]
      ["mealie"        "mealie"      9092]
    ];
  };
}
