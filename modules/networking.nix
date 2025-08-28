{ ... }: {
 # networking & security
  networking.hostName = "mainpc"; # hostname
  networking.firewall.allowedTCPPorts = [53317]; # 53317 is used by local-send
  networking.enableIPv6 = false;

  networking.networkmanager.enable = true; # use networkmanager

  # Let resolv.conf be managed automatically
  networking.useHostResolvConf = false;
  environment.etc."resolv.conf".source = "/run/systemd/resolve/stub-resolv.conf";

  # Enable systemd-resolved
  services.resolved = {
    enable = true;
    dnssec = "false";           # optional
    dnsovertls = "false";       # optional
    domains = [];             # your search domains, if any
    # fallbackDns = [ "1.1.1.1" "1.0.0.1" ];         # fallback if DHCP fails
    extraConfig = ''
      # Ensure stub resolver is enabled
      DNSStubListener=yes
    '';
  };
}
