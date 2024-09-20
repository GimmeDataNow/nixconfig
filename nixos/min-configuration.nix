{ inputs, config, pkgs, lib,  ...}: 
let
  # define additional channels here that can later be used via 
  # unstable.<package>
  # in order to switch between versions. This will cause 
  # nixos-rebuild to fail without the --impure flag
  stable = import <nixos-stable> { config = { allowUnfree = true; nixpkgs.config.allowBroken = true; }; };
  unstable = import <nixos-unstable> { config = { allowUnfree = true; nixpkgs.config.allowBroken = true; }; };
in 

{
  # imports (keep it minimal here)
  imports = [
    ./hardware-configuration.nix # hardware stuff
  ];

  # nixpkgs.overlays = [
              # (final: prev: {
               # _espanso-orig = prev.espanso;
               # espanso = config.programs.espanso-capdacoverride.packageOverriden;
               # })
            # ];
  # programs.espanso-capdacoverride = {
            # enable = true;
            # package = unstable.espanso-wayland;

            # package = pkgs._espanso-orig;
          # };


  # bootloader options
  boot.loader.systemd-boot.enable = true; # use systemd-boot
  boot.loader.efi.canTouchEfiVariables = true; # avoid potential issues with efi
  # boot.kernelPackages = pkgs.linuxPackages_latest; # newest nixos linux kernel version != lastest kernel version
  boot.kernelPackages = pkgs.linuxPackages_6_6_hardend; # newest nixos linux kernel version != lastest kernel version
  # boot.kernelPackages = pkgs.linuxPackages_xanmod_latest; # https://discourse.nixos.org/t/unable-to-build-nix-due-to-nvidia-drivers-due-or-kernel-6-10/49266/17
  boot.kernelParams = [ 
    # "initcall_blacklist=simpledrm_platform_driver_init" # https://github.com/hyprwm/Hyprland/issues/6967#issuecomment-2241948730
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1" # https://wiki.hyprland.org/Nvidia/#suspendwakeup-issues
  ];

  # networking
  networking.hostName = "nixos"; # hostname
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

    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  };
  programs.xwayland.enable = true;
  xdg.portal = {
    enable = true;
  };

  # nvidia fluff
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ]; # use nvidia
  hardware.nvidia = {
    modesetting.enable = true; # speed regulation
    powerManagement.enable = true; # might crash otherwise
    powerManagement.finegrained = false; # might crash otherwise
    open = false; # opensource
    nvidiaSettings = true; # nvidia app
    package = config.boot.kernelPackages.nvidiaPackages.latest; # driver version
    # package = config.boot.kernelPackages.nvidiaPackages.mkDriver { 
      # this is a custom version of the nvida driver that is not
      # yet available for download per default installation 
      # version = "555.58";
      # sha256_64bit = "sha256-bXvcXkg2kQZuCNKRZM5QoTaTjF4l2TtrsKUvyicj5ew=";
      # sha256_aarch64 = "sha256-7XswQwW1iFP4ji5mbRQ6PVEhD4SGWpjUJe1o8zoXYRE=";
      # openSha256 = "sha256-hEAmFISMuXm8tbsrB+WiUcEFuSGRNZ37aKWvf0WJ2/c=";
      # settingsSha256 = "sha256-vWnrXlBCb3K5uVkDFmJDVq51wrCoqgPF03lSjZOuU8M=";
      # persistencedSha256 = lib.fakeHash; # cant be bothered to find out the proper hash
    # };
  };

  # security
  security.polkit.enable = true;
  
  # nixfeatures
  # allow for flakes and nix commands that are still marked as unstable
  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 
  # should probably be higher up in the nix config but this
  # enables unfree, insecure and broken packages to be installed
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowInsecure = true;
  nixpkgs.config.allowBroken = true;

  # prevent chromeium apps from breaking
  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
    "electron-19.1.9"
  ];

  # target system version
  system.stateVersion = "24.05";

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
  users.users.hallow = {
    password = "hallow";
    isNormalUser = true;
    description = "default user";
    extraGroups = [ "networkmanager" "wheel" "input" "udev" ];
    packages = with pkgs; [ 
    # empty here because I allow all packages to be
    # accessible by all users anyways
    ];
  };


  # autologin
  services.getty.autologinUser = "hallow"; # skip the login

  # bitwarden security
  services.gnome.gnome-keyring.enable = true; # bitwarden will fail to run if this is not enabled

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
    MOZ_ENABLE_WAYLAND = "0";
    # others
    EDITOR = "hx";
    RANGER_LOAD_DEFAULT_RC = "FALSE"; # make ranger not load both configs

    # lutris itch.io fix
    WEBKIT_DISABLE_DMABUF_RENDERER = "1";

    # fixing these shitty dotfiles in my directory
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    CUDA_CACHE_PATH ="$XDG_CACHE_HOME/nv";
    # CARGO_HOME = "$XDG_DATA_HOME/cargo";
  };

  # aliasing and some other bash-env 
  environment.interactiveShellInit = ''
    alias e='hx'
    alias less='bat'
    alias lsblk='lsblk -t -o RO,RM,HOTPLUG,NAME,SIZE,UUID,MODE,PATH,MODEL'
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
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };
  # hardware.logitech.wireless.enable = true;

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
    tealdeer # better tldr command
    bc # calculator

    # logitech-udev-rules
    # solaar
    input-remapper

    
    # gui
    # unstable.hyprland # window manager
    pwvucontrol # audio control
    # unstable.firefox-wayland # browser
    # firefox-beta-unwrapped
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
    # mission-center # system monitor

    # code
    vscode.fhs # vscode
    nil # nix language server
    
    # personal
    unstable.xwaylandvideobridge # allows for screensharing
    freetube # better youtube desktop
    obs-studio # obs
    mpv # video playern
    nur.repos.nltch.spotify-adblock # spotify adblock
    unstable.obsidian # notetaking
    anki # learning cards

    # communication
    stable.vesktop # discord
    xdg-utils # xdg-settings and more (set default browser)

    # gaming
    steam # steam
    wineWowPackages.stable # additional packages for lutis (may not be needed)
    lutris # windows games on linux
    winetricks # execute this to fix wine
    heroic # heroic games launcher

    # theme
    glib # needed for gnome
    gnome3.adwaita-icon-theme # makes wm not crash
    lxappearance-gtk2 # icon theme changer
  ];
}
