{ lib }:

name: port: index:
{
  "containers.${name}" = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.0.110";
    # to avoid reserved ip addr add 10 or any other number
    localAddress = "192.168.0.${toString (10 + index)}";

    config = { config, pkgs, ... }: {
      networking.useHostNetwork = true;
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
    };
  };
}
