# modules/common/spicetify.nix
#
# This module builds the spiced Spotify package via spicetify-nix.lib.mkSpicetify
# and adds it to environment.systemPackages.
# It expects two _module.args:
#   - spicetifyLib: inputs.spicetify-nix.lib
#   - spicePkgset: inputs.spicetify-nix.legacyPackages.${system}
#
{ pkgs, spicetifyLib, spicePkgset, ... }:

let
  # Build the wrapped Spotify package using the wrapper helper.
  spicedSpotify = spicetifyLib.mkSpicetify pkgs {
    # use extensions and themes from the spice package set passed in
    extensions = with spicePkgset.extensions; [
      adblockify
      hidePodcasts
      shuffle
    ];

    theme = spicePkgset.themes.catppuccin;
    colorScheme = "mocha";

    # other options can be placed here if desired, e.g. patchFiles, build inputs etc.
  };
in
{
  # Add the resulting package to the system environment so it's installed system-wide.
  environment.systemPackages = [
    spicedSpotify
  ];

  # Optionally expose the package via a name if you want:
  # environment.systemPackages = [ spicedSpotify ];
}
