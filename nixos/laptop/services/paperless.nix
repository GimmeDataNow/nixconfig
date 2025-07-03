{ config, lib, pkgs, containerDef, ... }:

{
  services.paperless = {
    enable = true;
    port = containerDef.hostPort;
    address = "0.0.0.0";
  };
}
