{ ... }: {
  users.users.hallow = {
    isNormalUser = true; # sets up the home directory and set a few misc. variables
    hashedPassword = "$y$j9T$.1SJTv4b5xb74jNuW5Jos0$saRV3GfwAEGo1M70hUmoQsPs2TIl.klI09rJYD2bl18"; # mkpasswrd -m Yescrypt <password>
    description = "default user";
    extraGroups = ["networkmanager" "wheel" "scanner" "lp"]; # add additional capability groups here
  };
  services.getty.autologinUser = "hallow";
}
