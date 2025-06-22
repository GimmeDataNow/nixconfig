{ config, pkgs, lib, inputs, ... }:

let
# ../services/mk-utils/mk-suwayomi-container.nix
  mkSuwayomiContainer = import ../services/mk-utils/mk-suwayomi-container.nix { inherit lib; };

  containerSpecs = [
    # (mkSuwayomiContainer "suwayomi1" 4567)
    (mkSuwayomiContainer "suwayomi2" 4568)
    (mkSuwayomiContainer "suwayomi3" 4569)
  ];

  # Apply index during mapping
  containerDefs = lib.imap0 (index: containerFunc: containerFunc index) containerSpecs;

in {
  config = lib.mkMerge containerDefs;
}



