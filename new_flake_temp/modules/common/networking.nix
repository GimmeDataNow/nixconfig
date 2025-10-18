# ./modules/networking/mainpc.nix
{ ... }:

{
  options = {};  # You can leave this empty unless you define custom options.

  config = {

    # --- Networking & Security ---
    networking.firewall.allowedTCPPorts = [
      12315  # Grayjay
      53317  # LocalSend
    ];

    networking.enableIPv6 = false;

    # Use NetworkManager
    networking.networkmanager.enable = true;

    # Let resolv.conf be managed automatically
    networking.useHostResolvConf = false;
    environment.etc."resolv.conf".source = "/run/systemd/resolve/stub-resolv.conf";

    # Enable systemd-resolved
    services.resolved = {
      enable = true;
      dnssec = "false";     # optional
      dnsovertls = "false"; # optional
      domains = [];         # optional
      # fallbackDns = [ "1.1.1.1" "1.0.0.1" ]; # optional fallback

      extraConfig = ''
        # Ensure stub resolver is enabled
        DNSStubListener=yes
      '';
    };

  };
}
