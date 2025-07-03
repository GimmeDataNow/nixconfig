{ config, lib, pkgs, containerDef, ... }:

{
  services.immich = {
    enable = true;
    port = containerDef.hostPort;
    host = "0.0.0.0";
  };
}
