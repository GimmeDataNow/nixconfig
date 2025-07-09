{ config, lib, pkgs, containerDef, ... }:

{
  services.actual = {
    enable = true;
    settings.port = containerDef.hostPort;
    # trusted proxies will have to be added here later
  };
}
