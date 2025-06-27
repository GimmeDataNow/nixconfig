{ config, lib, pkgs, containerDef, ... }:

{
  services.suwayomi-server = {
    enable = true;
    openFirewall = false; # The host manages the firewall.
    settings.server = {
      port = containerDef.hostPort;
      extensionRepos = ["https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"];
    };
  };
}
