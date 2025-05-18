{ inputs, config, pkgs, unstable, ...}: {
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true; # bitwarden will fail to run if this is not enabled
}
