{ config, lib, pkgs, containerDef, ... }:

{
  services.paperless = {
    enable = true;
    port = containerDef.hostPort;
    address = "0.0.0.0";
    settings = {
      PAPERLESS_URL = "https://documents.relaydomainforresearch.cc";
    };
  };
}
