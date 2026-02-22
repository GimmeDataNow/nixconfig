{ user, ... }: {
  imports = [
    ./hardware-configuration.nix     # VPS provider specific (usually generated)
    ../../modules/nixos/common       # Your core user/system settings
    ../../modules/nixos/server.nix   # The module we just created above
  ];

  networking.hostName = "my-vps";

  # VPS specific: Add your public SSH key here so you can login!
  users.users.${user}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3Nza... your-public-key"
  ];

  system.stateVersion = "23.11"; # Match the version you installed with
}
