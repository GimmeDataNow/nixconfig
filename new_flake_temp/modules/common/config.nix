{ pkgs, ... }:

{
  # Allow unfree packages like Visual Studio Code, Spotify, etc
  nixpkgs.config.allowUnfree = true;

  # Make sure your system.version is set
  system.stateVersion = "25.05";
}
