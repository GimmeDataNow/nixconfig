{ config, lib, pkgs, containerDef, ... }:

{
  services.immich = {
    enable = true;
    port = containerDef.hostPort;
  };
}
