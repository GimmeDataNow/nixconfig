{ pkgs, lib, ... }: {
  # --- SECURITY ---
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;  # Force SSH keys only
      PermitRootLogin = "prohibit-password"; 
    };
    # Automatically open the firewall for SSH
    openFirewall = true; 
  };

  # Fail2Ban: Bans IPs that try to brute force your SSH
  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [
      "127.0.0.1/8"
      # "your.home.ip.here" # Add your home IP to avoid locking yourself out
    ];
  };

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
