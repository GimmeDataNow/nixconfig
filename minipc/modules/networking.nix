{ ... }: {
 # networking & security
  networking.hostName = "minipc"; # hostname
  networking.networkmanager.enable = true; # use networkmanager
  networking.firewall.allowedTCPPorts = [22 53317]; # 53317 is used by local-send

  networking.nat = {
    enable = true;
    externalInterface = "enp2s0"; # Change this to your actual external interface!
    internalInterfaces = [ "ve-+" ]; # Matches all veth interfaces created by containers
  };
}
