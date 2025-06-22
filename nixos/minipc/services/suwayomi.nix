{ config, pkgs, lib, inputs, ... }:

let
  # Import the mkSuwayomiContainer helper function
  mkSuwayomiContainer = import ../services/mk-utils/mk-suwayomi-container.nix { inherit lib; };

  # Your list of container instances
  containerSpecs = [
    (mkSuwayomiContainer "suwayomi2" 4568)
    (mkSuwayomiContainer "suwayomi3" 4569)
    (mkSuwayomiContainer "suwayomi4" 4570)
  ];

  # Map over them with index, getting container + port back
  containerDefsWithMeta = lib.imap0 (index: f: f index) containerSpecs;

  # Merge container definitions into a flat attribute set
  containerDefs = lib.foldl' (acc: next: acc // next.container) {} containerDefsWithMeta;

  # Collect the ports that should be opened on the host
  hostPorts = map (x: x.port) containerDefsWithMeta;

in {
  config = {
    containers = containerDefs;

    # Open all ports needed by the containers on the host
    networking.firewall.allowedTCPPorts = hostPorts;

    # Enable NAT for containers with private networks
    networking.nat = {
      enable = true;
      internalInterfaces = [ "ve-+" ];
      externalInterface = "enp2s0"; # <- Replace this with your actual interface name
    };
  };
}
