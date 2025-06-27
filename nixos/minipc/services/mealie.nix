{ config, lib, pkgs, containerDef, ... }:

{
  services.mealie = {
    enable = true;
    port = containerDef.hostPort;
  };
}
