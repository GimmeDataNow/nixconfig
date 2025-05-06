{ inputs, config, pkgs, lib,  ...}: 
let
  stable = import <nixos-stable> { config = { allowUnfree = true; nixpkgs.config.allowBroken = true; }; };
  unstable = import <nixos-unstable> { config = { allowUnfree = true; nixpkgs.config.allowBroken = true; }; };
in 

{
  imports = [
    ./hardware-configuration.nix # hardware stuff
  ];
  
  # bootloader options
  boot.loader.systemd-boot.enable = true; # use systemd-boot
  boot.loader.efi.canTouchEfiVariables = true; # avoid potential issues with efi
  boot.kernelPackages = unstable.linuxPackages_6_14;
  boot.initrd.kernelModules = [ "amdgpu" ];

  # networking
  networking.hostName = "laptop"; # hostname
  networking.networkmanager.enable = true; # use networkmanager
  networking.firewall.allowedTCPPorts = [ 53317 ]; # 53317 is used by local-send

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

  # hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  programs.xwayland.enable = true;
  xdg.portal = {
    enable = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" ]; # use nvidia

  # security
  security.polkit.enable = true;
  
  # nixfeatures
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowInsecure = true;
  nixpkgs.config.allowBroken = true;

  # target system version
  system.stateVersion = "24.11";

  # sound
  security.rtkit.enable = true; # this allows pipewire to handle realtime priority
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true; # wireplumber commands
  };

  # default user
  services.getty.autologinUser = "hallow"; # skip the login
  users.users.hallow = {
    isNormalUser = true;
    hashedPassword = "$y$j9T$doJaUYVyR2mGgRyfiYWv5/$D/2ghzNMTuDFpf5oX9x3Fj/o0UTVMCJub9ywC0NJ0q2";
    description = "default user";
    extraGroups = [ "networkmanager" "wheel" "input" "udev" ];
  };

  # bitwarden security
  services.gnome.gnome-keyring.enable = true; # bitwarden will fail to run if this is not enabled

  # important session/bash variables
  environment.sessionVariables = {
    # hyprland vars
    XDG_SESSION_TYPE = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";

    # others
    EDITOR = "hx";

    # fixing these shitty dotfiles in my directory
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    CUDA_CACHE_PATH ="$XDG_CACHE_HOME/nv";
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
    serif = [ "UbuntuMono Nerd Font" ];
    sansSerif = [ "UbuntuSansMono Nerd Font" ];
    monospace = [ "UbuntuMono Nerd Font Mono" ];
  };

  # import the nix-user-repo
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchGit {
      url = "https://github.com/NL-TCH/nur-packages.git";
      ref = "master";
      rev = "d7c48ab53778bb9c63458c797d8f2db0a57f191c";
    }) {
      inherit pkgs;
    };
  };

  # packages
  environment.systemPackages = with pkgs; [
  
    # tui/cli
    kitty # terminal emulator
    vim # basic text editor
    unstable.helix # vim alternative in rust
    xclip # clipboard manager for files
    git # git
    pipewire # audio system
    wireplumber # manager for the audio system
    ranger # tui file explorer
    yazi # tui file explorer
    btop # system monitor
    unzip # unzip
    wl-clipboard # fixes the clipboard for wayland
    playerctl # media controller
    starship # better bash prompt
    ecryptfs # encryption
    ouch # universal unarchiver
    glow # markdown viewer
    bat # better pager and better cat
    bc # calculator

    # gui
    pwvucontrol # audio control
    unstable.firefox
    rofi-wayland # app launcher
    waybar (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      })
    ) # top bar
    wev # get keyboard inputs
    dunst # notification manager
    swww # desktop background
    pavucontrol
    imv # terminal image viewer
    unstable.bitwarden-desktop # password manager
    # screenshot
    grim # grab area from wayland compositor
    slurp # mark an area from the wayland compositor
    swappy # save a buffer as an image
    qalculate-qt # calculator
    localsend # airdrop
    sirikali # encryption manager
    hyprpicker # color picker for hyprland

    # code
    # vscode.fhs # vscode
    nil # nix language server
    
    # personal
    kdePackages.xwaylandvideobridge# allows for screensharing
    obs-studio # obs
    mpv # video playern
    nur.spotify-adblock # spotify adblock
    unstable.obsidian # notetaking
    # anki # learning cards

    # communication
    stable.vesktop # discord
    xdg-utils # xdg-settings and more (set default browser)

    # gaming
    steam # steam
    heroic # heroic games launcher

    # theme
    glib # needed for gnome
    gnome3.adwaita-icon-theme # makes wm not crash
    lxappearance-gtk2 # icon theme changer
  ];
}
