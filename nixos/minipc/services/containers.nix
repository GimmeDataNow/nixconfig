{ lib, config, ... }:

let
  containerLib = import ../modules/containers-lib.nix { inherit lib; };
  
  containersList = [
    (containerLib.makeContainer "webserver" 8080 8080)     # nginx on port 8080
    (containerLib.makeContainer "sshserver" 2222 2222)     # SSH on port 2222  
    (containerLib.makeImmichContainer "immich" 3001 3001)  # Immich on port 3001
  ];
  
  # Container ports to ADD to existing firewall rules
  containerPorts = [8080 2222 3001];
  
  # Merge all container configurations
  mergedConfig = lib.foldl' lib.recursiveUpdate {} containersList;

in
{
  # Enable containers
  boot.enableContainers = true;
  
  # ADD container ports to whatever is already in allowedTCPPorts
  networking.firewall.allowedTCPPorts = config.networking.firewall.allowedTCPPorts ++ containerPorts;
  
  # Apply merged configuration
  inherit (mergedConfig) containers networking systemd;
}
