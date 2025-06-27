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
    ./services/ssh.nix
    ./services/docker.nix
    # ./services/suwayomi.nix

    # ./services/containers.nix

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
      { name = "suwayomi";      service = "suwayomi"; hostPort = 4567; }
      { name = "suwayomi-nsfw"; service = "suwayomi"; hostPort = 4568; }
      { name = "mealie";        service = "mealie";   hostPort = 9092; }
      # { name = "suwayomi-testing"; service = "suwayomi"; hostPort = 2222; }
      # { name = "paperless"; service = "paperless"; hostPort = 8080; }
    ];
  };
}
