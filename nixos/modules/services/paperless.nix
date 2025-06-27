{ config, lib, pkgs, containerDef, ... }:

{
  services.paperless = {
    enable = true;
    port = containerDef.hostPort;
  };
}
