# ../services/mk-utils/mk-suwayomi-container.nix
{ lib }:

name: port:
index:
let
  ipSuffix = toString (10 + index);
  containerIp = "192.168.100.${ipSuffix}";
in {
  container = {
    "${name}" = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.1";
      localAddress = containerIp;

      config = { config, pkgs, lib, ... }: {
        services.suwayomi-server = {
          enable = true;
          openFirewall = true;
          settings.server = {
            port = port;
            extensionRepos = [
              "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"
            ];
          };
        };

        networking.firewall.allowedTCPPorts = [ port ];
        networking.useHostResolvConf = lib.mkForce false;
        services.resolved.enable = true;

        system.stateVersion = "24.05";
      };
    };
  };

  port = port;
}
