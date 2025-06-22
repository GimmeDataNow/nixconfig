{ ... }: {
 # networking & security
  networking.hostName = "minipc"; # hostname
  networking.networkmanager.enable = true; # use networkmanager
  networking.firewall.allowedTCPPorts = [22 53317]; # 53317 is used by local-send
  services.resolved.enable = true;
}
