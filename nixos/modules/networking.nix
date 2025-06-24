{ ... }: {
 # networking & security
  networking.hostName = "mainpc"; # hostname
  networking.networkmanager.enable = true; # use networkmanager
  networking.firewall.allowedTCPPorts = [53317]; # 53317 is used by local-send
  services.resolved.enable = true;
  networking.enableIPv6 = false;
}
