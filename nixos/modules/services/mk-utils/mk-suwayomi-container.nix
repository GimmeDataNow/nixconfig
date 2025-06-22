{ lib }:

name: port: index:
{
  containers = {
    "${name}" = {
      autoStart = true;

      useHostNetwork = true;
      
      # privateNetwork = true;
      # hostAddress = "192.168.0.110";
      # localAddress = "192.168.0.${toString (10 + index)}";

      config = { config, pkgs, ... }: {

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
  };
}
