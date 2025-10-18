# ./systems/mainpc/default.nix
{ ... }: {
  imports = [
    ../../modules/common/config.nix
    
    ../../modules/mainpc/hardware.nix
    ../../modules/common/boot.nix
    ../../modules/mainpc/users.nix

    ../../modules/common/time_locale.nix
    ../../modules/common/security.nix
    ../../modules/common/environment.nix
    ../../modules/common/networking.nix

    ../../modules/common/fonts.nix
    ../../modules/common/sound.nix
    ../../modules/common/printer.nix
    ../../modules/common/desktop.nix

    ../../modules/common/programs.nix

    # ../../modules/common/spicetify.nix
    
  ];

  networking.hostName = "mainpc";
}
