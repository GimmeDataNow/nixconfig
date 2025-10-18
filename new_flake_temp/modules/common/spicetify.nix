{ pkgs, inputs, system, ... }:

let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${system};
in
{
  programs.spicetify = {
    enable = true;

    theme = spicePkgs.themes.catppuccin;
    colorScheme = "macchiato";

    enabledExtensions = with spicePkgs.extensions; [
      adblockify
      hidePodcasts
      shuffle
    ];
  };

  environment.systemPackages = [ pkgs.zenity ];
};
