{ config, lib, pkgs, containerDef, ... }:

{
  services.flaresolverr = {
    enable = true;
    port = containerDef.hostPort;
  };
}
