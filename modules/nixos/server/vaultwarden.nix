{ pkgs, unstable, ... }: {
  # services.tailscale.enable = true;
  services.vaultwarden = {
    enable = true;
    config = {
      DOMAIN = "https://minipc.tail554692.ts.net";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
    };
    # package = unstable.vaultwarden;
  };

  # services.caddy = {
  #   enable = true;
  #   virtualHosts."minipc.tail554692.ts.net".extraConfig = ''
  #     reverse_proxy localhost:8222
  #   '';
  # };

  # networking.firewall.allowedTCPPorts = [ 80 443 ];
  # networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # systemd.services.caddy.serviceConfig.SupplementaryGroups = [ "tailscale" ];

}
