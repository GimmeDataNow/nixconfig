{
  inputs,
  config,
  pkgs,
  ...
}: let
  # define additional channels here that can later be used via
  # unstable.<package>
  # in order to switch between versions. This will cause
  # nixos-rebuild to fail without the --impure flag
  stable = import <nixos-stable> {
    config = {
      allowUnfree = true;
      nixpkgs.config.allowBroken = true;
    };
  };
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
      nixpkgs.config.allowBroken = true;
    };
  };
in {
  # nixfeatures
  # allow for flakes and nix commands that are still marked as unstable
  nix.settings.experimental-features = ["nix-command" "flakes"];
  # should probably be higher up in the nix config but this
  # enables unfree, insecure and broken packages to be installed
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowInsecure = true;
  nixpkgs.config.allowBroken = true;

  # imports (keep it minimal here)
  imports = [
    ./hardware-configuration.nix # hardware stuff
    ./services/suwayomi.nix
  ];

  # bootloader options
  boot.loader.systemd-boot.enable = true; # use systemd-boot
  boot.loader.efi.canTouchEfiVariables = true; # avoid potential issues with efi
  boot.kernelPackages = unstable.linuxPackages_6_11; # newest nixos linux kernel version != lastest kernel version

  # users
  users.users.minipc = {
    isNormalUser = true; # sets up the home directory and set a few misc. variables
    password = "minipc"; # mkpasswrd -m Yescrypt <password>
    description = "The minipc that host some services"; # minor additional info
    extraGroups = ["networkmanager" "wheel" "docker"]; # add additional capability groups here
  };

  # autologin
  services.getty.autologinUser = "minipc"; # skip the login
  security.polkit.enable = true;

  # networking & security
  networking.hostName = "minipc"; # hostname
  networking.networkmanager.enable = true; # use networkmanager
  networking.firewall.allowedTCPPorts = [22 53317]; # 53317 is used by local-send
  services.gnome.gnome-keyring.enable = true; # bitwarden will fail to run if this is not enabled

  services.openssh = {
    enable = true;
    ports = [22];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = null;
      UseDns = true;
      X11Forwarding = false;
    };
  };

  # docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # time
  time.timeZone = "Europe/Berlin";

  # locale
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # configure console keymap
  console.keyMap = "de";

  # target system version
  system.stateVersion = "24.11";

  # important session/bash variables
  environment.sessionVariables = {
    # others
    EDITOR = "hx";
    RANGER_LOAD_DEFAULT_RC = "FALSE"; # make ranger not load both configs

    # fixing these shitty dotfiles in my directory
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
  };

  # aliasing and some other bash-env
  environment.interactiveShellInit = ''
    alias e='hx'
    alias less='bat'
    alias lsblk='lsblk -t -o RO,RM,HOTPLUG,NAME,SIZE,UUID,MODE,PATH,MODEL'
    function y() {
     local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
     yazi "$@" --cwd-file="$tmp"
     if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      builtin cd -- "$cwd"
     fi
     rm -f -- "$tmp"
    }
  '';

  # fonts
  fonts.packages = with pkgs; [
    nerdfonts # nerdfonts is a massive package but I dont care
  ];

  # ubuntumono nerd font for utf8 symbols and nice font
  fonts.fontconfig.defaultFonts = {
    serif = ["UbuntuMono Nerd Font"];
    sansSerif = ["UbuntuSansMono Nerd Font"];
    monospace = ["UbuntuMono Nerd Font Mono"];
  };

  # packages
  environment.systemPackages = with pkgs; [
    # tui/cli
    kitty # terminal emulator
    vim # basic text editor
    unstable.helix # vim alternative in rust
    xclip # clipboard manager for files
    git # git
    ranger # tui file explorer
    yazi # tui file explorer
    btop # system monitor
    unzip # unzip
    wl-clipboard # fixes the clipboard for wayland
    starship # better bash prompt
    ouch # universal unarchiver
    glow # markdown viewer
    bat # better pager and better cat

    localsend # airdrop
    nil # nix language server
  ];
}
