{ config, unstable, pkgs, inputs, disko, user, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
    ../../modules/nixos/server/reticulum-server.nix

    ../../modules/nixos/desktop/programs/cli.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader
  boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/vda"; 

  boot.initrd.availableKernelModules = [ 
    "virtio_pci" 
    "virtio_blk" 
    "virtio_scsi" 
    "virtio_balloon"
  ];

  # Networking
  networking = {
    hostName = "gateway";
    useDHCP = true;
    interfaces.ens3.ipv4.addresses = [ { address = "31.56.233.116"; prefixLength = 24; } ];
    defaultGateway = "31.56.233.1";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    firewall.allowedTCPPorts = [
      22 # ssh
      80 # pangolin
      443 # pangolin
    ];
    firewall.allowedUDPPorts = [
      21820 # pangolin
      51820 # pangolin
    ];

  };


  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      KbdInteractiveAuthentication = false;
      X11Forwarding = false;
    };
  };

  # prevent bruteforce attacks

  services.fail2ban = {
    enable = true;
    maxretry = 3; # ban after 3 tries
    bantime = "1h";

    # don't ban these ips
    ignoreIP = [
      "127.0.0.1/8"
      "::1"
      "137.226.218.185"
    ];

    bantime-increment = {
      enable = true;
      rndtime = "15m"; # Keep botnets guessing when they get unbanned
    };

    jails = {
      recidive = {
        settings = {
          enabled = true;
          maxretry = 3;
          findtime = "2d"; # what window to check for repeat offenders
          bantime = "1w"; # Put serial offenders in "super-jail" for a week
        };
      };
    };
  };

  # User and SSH keys
  users.users.hallow = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    hashedPassword = "$6$f64J0RqxjCAZfIH0$P/aVfYOw6ReR2veH5cyoVxdMlRIf1svM7i68lLTcCJEsnZ7P8nRPYqdkwROHg/xAYjRG8Zr6W8q6OqdSm8Avp.";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOgsEnykX81QlWJyUQxsKSbJV4g3WwckVH31o5jXO5ot hallow@desktop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII4CLEZFzXYaJMZ95RFC7GGpxOUJstTXQ/lgOLo9Lvlc hallow@laptop"
    ];
  };

  # Docker
  virtualisation.docker.enable = true;

  # UTIL
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs unstable user; };
    backupFileExtension = "bak";
    users.${user} = {
      imports = [
        ../../modules/home/shell.nix
        ../../modules/home/starship.nix
        ../../modules/home/kitty.nix
        ../../modules/home/yazi.nix
        ../../modules/home/helix.nix
      ];
      home.stateVersion = "26.05";
    };
  };
  

  # NixOS version
  system.stateVersion = "26.05";
}
