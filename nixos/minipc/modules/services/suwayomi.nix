# /etc/nixos/modules/services/suwayomi.nix
#
# This module configures the suwayomi-server service inside a container.

{ config, lib, pkgs, ... }:

# `specialArgs` from the factory passes our container definition here.
{ containerDef, ... }:

{
  # Configure the suwayomi-server service.
  services.suwayomi-server = {
    enable = true;
    openFirewall = false; # The host manages the firewall.
    settings.server = {
      # Use the port that was assigned to this container in the main config list.
      port = containerDef.hostPort;
      # The rest of your settings.
      extensionRepos = ["https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"];
    };
  };

  # By enabling the service, NixOS automatically creates the `suwayomi-server` user,
  # satisfying the requirement to run as the intended user.
}
