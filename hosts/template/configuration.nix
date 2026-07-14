{ config, pkgs, disko, ... }:

{
  # Import auto-generated hardware configuration (usually /etc/nixos/hardware-configuration.nix)
  imports = [
    ./hardware-configuration.nix
    ./disko-config.nix
  ];

  # 1. Bootloader (usually /dev/vda or /dev/sda for VPS)
  boot.loader.grub.enable = true;
  # boot.loader.grub.device = "/dev/vda"; 

  boot.initrd.availableKernelModules = [ 
    "virtio_pci" 
    "virtio_blk" 
    "virtio_scsi" 
    "virtio_balloon"
  ];

  # 2. Networking (Adjust interface name using `ip a`)
  networking.hostName = "gateway";
  networking.useDHCP = true;
  networking.interfaces.ens3.ipv4.addresses = [ { address = "31.56.233.116"; prefixLength = 24; } ];
  networking.defaultGateway = "31.56.233.1";
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # 3. Enable SSH for remote access (CRITICAL)
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.PermitRootLogin = "prohibit-password";

  # 4. Define your user and add your SSH public key
  users.users.hallow = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable sudo
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOgsEnykX81QlWJyUQxsKSbJV4g3WwckVH31o5jXO5ot hallow@desktop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII4CLEZFzXYaJMZ95RFC7GGpxOUJstTXQ/lgOLo9Lvlc hallow@laptop"
    ];
  };

  # 5. Allow essential firewall traffic
  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  # 6. NixOS release version (Match your installation ISO)
  system.stateVersion = "26.05"; # or your installed version
}
