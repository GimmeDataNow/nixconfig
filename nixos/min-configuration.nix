{ inputs, config, pkgs, lib,  ...}: 
let
  # define channels here for switching
  stable = import <nixos-stable> { config = { allowUnfree = true; nixpkgs.config.allowBroken = true; }; };
  unstable = import <nixos-unstable> { config = { allowUnfree = true; nixpkgs.config.allowBroken = true; }; };
in 

{
  # imports (keep it minimal here)
  imports = [
    ./hardware-configuration.nix
  ];

  # bootloader options
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "kvm-amd"];

  # networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 80 443 53317 ];

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

  # configure keymap in X11
  services.xserver = {
    #enable = true;
    xkb.layout = "de";
    xkb.variant = "";
  };

  # enable vfs compatible service
  # services.envfs.enable = true;

  # hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  programs.xwayland.enable = true;
  xdg.portal = {
    enable = true;
  };

  # nvidia
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true; # speed regulation
    powerManagement.enable = false; # might crash otherwise
    powerManagement.finegrained = false; # might crash otherwise
    open = false; # opensource
    nvidiaSettings = true; # nvidia app
    # package = config.boot.kernelPackages.nvidiaPackages.production; # driver version
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "555.58";
      sha256_64bit = "sha256-bXvcXkg2kQZuCNKRZM5QoTaTjF4l2TtrsKUvyicj5ew=";
      sha256_aarch64 = "sha256-7XswQwW1iFP4ji5mbRQ6PVEhD4SGWpjUJe1o8zoXYRE=";
      openSha256 = "sha256-hEAmFISMuXm8tbsrB+WiUcEFuSGRNZ37aKWvf0WJ2/c=";
      settingsSha256 = "sha256-vWnrXlBCb3K5uVkDFmJDVq51wrCoqgPF03lSjZOuU8M="; #"sha256-m2rNASJp0i0Ez2OuqL+JpgEF0Yd8sYVCyrOoo/ln2a4=";
      persistencedSha256 = lib.fakeHash; #"sha256-XaPN8jVTjdag9frLPgBtqvO/goB5zxeGzaTU0CdL6C4=";
    };
  };

  # security
  security.polkit.enable = true;
  
  # nixfeatures
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowInsecure = true;
  nixpkgs.config.allowBroken = true;

  # prevent chromeium apps from braking
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
    "electron-19.1.9"
  ];

  # target system version
  system.stateVersion = "24.05";

  # sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # default user
  users.users.hallow = {
    password = "hallow";
    isNormalUser = true;
    description = "default user";
    extraGroups = [ "networkmanager" "wheel" "uinput" ];
    packages = with pkgs; [
    ];
  };


  # autologin
  services.getty.autologinUser = "hallow";

  # bitwarden security
  services.gnome.gnome-keyring.enable = true;
  # services.passSecretService.enable = true;

  # important session/bash variables
  environment.sessionVariables = {
    # hyprland vars
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";

    # experimental
    __GL_VRR_ALLOWED = "0";
    __GL_GSYNC_ALLOWED = "0";

    # others
    EDITOR = "hx";
    RANGER_LOAD_DEFAULT_RC = "FALSE"; # make ranger not load both configs

    # lutris itch.io fix
    WEBKIT_DISABLE_DMABUF_RENDERER = "1";
  };

  # aliasing and some other bash-env 
  environment.interactiveShellInit = ''
    alias e='nvim'
    alias lsblk='lsblk -t -o RO,RM,HOTPLUG,NAME,SIZE,UUID,MODE,PATH,MODEL'
    alias nix-dev-rust='nix-shell ~/nixos/nix-shell/rust.nix'
  '';

  # fonts
  fonts.packages = with pkgs; [
    # noto-fonts
    # noto-fonts-cjk
    # noto-fonts-emoji
    # liberation_ttf
    # fira-code
    # fira-code-symbols
    # mplus-outline-fonts.githubRelease
    # dina-font
    # proggyfonts
    # font-awesome
    nerdfonts
    # terminus-nerdfont
    # (nerdfonts.override { fonts = [ "DejaVuSansMNerdFontMono" ]; })
  ];

  # ubuntumono nerd font for utf8 symbols and nice font
  fonts.fontconfig.defaultFonts = {
    serif = [ "UbuntuMono Nerd Font" ];
    sansSerif = [ "UbuntuSansMono Nerd Font" ];
    monospace = [ "UbuntuMono Nerd Font Mono" ];
  };

  # import the nix-user-repo
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  # packages
  environment.systemPackages = with pkgs; [
  
    # tui/cli
    kitty # terminal emulator
    vim # basic text editor
    unstable.neovim # better text editor
    unstable.helix # vim alternative in rust
    xclip # clipboard manager for files
    git # git
    pipewire # audio system
    wireplumber # manager for the audio system
    ranger # tui file explorer
    yazi # tui file explorer
    btop # system monitor
    unzip # unzip
    lshw # ls for hardware
    wl-clipboard # fixes the clipboard for wayland
    xorg.setxkbmap # dep of espanso
    ecryptfs # encryption
    ouch
    glow
    
    # gui
    unstable.hyprland # window manager
    pwvucontrol # audio control
    firefox-wayland # browser
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

    # code
    unstable.vscode.fhs # vscode
    unstable.rustc # rust
    cargo # rust cargo
    python3 # pyhton 
    python311Packages.pillow # pillow for lightnovels
    nil # nix language server

    # gui personal
    unstable.xwaylandvideobridge # does not work
    unstable.freetube # better youtube desktop
    obs-studio # obs
    mpv # video player
    chromium # unfortunately needed for the poe browser extension
    nur.repos.nltch.spotify-adblock # spotify adblock

    # communication
    stable.vesktop # discord
    xdg-utils # xdg-settings and more (set default browser)

    # productive
    unstable.obsidian # notetaking

    # gaming
    #stable.minecraft # vanilla minecraft launcher
    #stable.prismlauncher # better minecraft launcher
    zulu17 # java for minecraft
    steam # steam
    wineWowPackages.stable # additional packages for lutis (may not be needed)
    lutris # windows games on linux
    winetricks # execute this to fix wine
    
    heroic # heroic games launcher
    # unstable.path-of-building # pob for poe
    # unstable.r2modman # r2modman / modmanager

    # theme
    glib # needed for gnome
    gnome3.adwaita-icon-theme # makes wm not crash
    lxappearance-gtk2 # icon theme changer

    # for waybar media manager
    playerctl
    
  ];
}
