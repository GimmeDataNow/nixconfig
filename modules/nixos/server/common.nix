{ pkgs, lib, ... }: {
  # --- SECURITY ---
  # services.openssh = {
  #   enable = true;
  #   settings = {
  #     PasswordAuthentication = false;
  #     KbdInteractiveAuthentication = false;
  #     PermitRootLogin = "prohibit-password";
  #   };

  #   # Space-separated list. Ensure there are no commas.
  #   extraConfig = ''
  #     Match Address 137.226.218.185,127.0.0.1,192.168.0.0/24,100.64.0.0/10
  #         PasswordAuthentication yes
  #         KbdInteractiveAuthentication yes
  #   '';
  # };
  services.openssh = {
    enable = true;
    settings = {
      # Global Defaults
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };

    # We use mkOrder to ensure this block is the very last thing in sshd_config
    extraConfig = lib.mkOrder 1000 ''
      Match Address 137.226.218.185,127.0.0.1,192.168.0.0/24,100.64.0.0/10
          PasswordAuthentication yes
          KbdInteractiveAuthentication yes
          AuthenticationMethods keyboard-interactive password publickey
    '';
  };
  
  # Fail2Ban: Bans IPs that try to brute force your SSH
  # services.fail2ban = {
  #   enable = true;
  #   maxretry = 5;
  #   ignoreIP = [
  #     "137.226.218.185"

  #     # Loopback
  #     "127.0.0.1/8"

  #     # LAN
  #     "192.168.0.0/24"
  #     # Tailscale CGNAT range
  #     "100.64.0.0/10"
  #   ];
  # };

  # --- NETWORKING & FIREWALL ---
  networking.firewall = {
    enable = true;
    # Allow standard web traffic if you're hosting a site later
    allowedTCPPorts = [ 80 443 ];
  };

  # --- MAINTENANCE ---
  # Automatically clean up old Nix generations to save disk space
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # --- PERFORMANCE ---
  # Use a lighter-weight documentation set for servers
  documentation.enable = false;
  documentation.nixos.enable = false;

  # Essential CLI tools for server management
  environment.systemPackages = with pkgs; [
    git
    vim
    htop
    tmux
    curl
    wget
    rsync
  ];
}
