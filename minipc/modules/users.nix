{ ... }: {
  users.users.minipc = {
    isNormalUser = true; # sets up the home directory and set a few misc. variables
    password = "minipc"; # mkpasswrd -m Yescrypt <password>
    description = "The minipc that host some services"; # minor additional info
    extraGroups = ["networkmanager" "wheel" "docker"]; # add additional capability groups here
  };
  
  services.getty.autologinUser = "minipc";
}
