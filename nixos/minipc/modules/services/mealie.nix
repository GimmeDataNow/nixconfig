{ config, lib, pkgs, containerDef, ... }:

{
  services.mealie = {
    enable = true;
    port = containerDef.hostPort;
    # openFirewall = false; # The host manages the firewall.
  };
}
