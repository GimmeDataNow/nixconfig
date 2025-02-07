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
  # enables unfree, insecure and broken packages to be installed
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowInsecure = true;
  nixpkgs.config.allowBroken = true;

  # imports (keep it minimal here)
  imports = [
    ./hardware-configuration.nix # hardware stuff

    inputs.xremap-flake.nixosModules.default
  ];
  # bootloader options
  boot.loader.systemd-boot.enable = true; # use systemd-boot
  boot.loader.efi.canTouchEfiVariables = true; # avoid potential issues with efi
  boot.kernelPackages = unstable.linuxPackages_6_11; # newest nixos linux kernel version != lastest kernel version

  hardware.uinput.enable = true;
  users.groups.uinput.members = ["hallow"];
  users.groups.input.members = ["hallow"];

  # users
  users.users.hallow = {
    isNormalUser = true; # sets up the home directory and set a few misc. variables
    hashedPassword = "$y$j9T$.1SJTv4b5xb74jNuW5Jos0$saRV3GfwAEGo1M70hUmoQsPs2TIl.klI09rJYD2bl18"; # mkpasswrd -m Yescrypt <password>
    description = "Alan O. User"; # minor additional info
    extraGroups = ["networkmanager" "wheel" "scanner" "lp"]; # add additional capability groups here
  };

  # autologin
  services.getty.autologinUser = "hallow"; # skip the login
  security.polkit.enable = true;

  # networking & security
  networking.hostName = "nixos"; # hostname
  networking.networkmanager.enable = true; # use networkmanager
  networking.firewall.allowedTCPPorts = [53317]; # 53317 is used by local-send
  services.gnome.gnome-keyring.enable = true; # bitwarden will fail to run if this is not enabled

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

  services.xremap = {
    withHypr = true;
    userName = "hallow";
    yamlConfig = ''
      keymap:
        - name: Ex
          application:
            not: firefox
          remap:
            CapsLock: Esc
    '';
  };

  services.xserver.videoDrivers = ["amdgpu"]; # use nvidia, this is critical for hyprland

  hardware.sane.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  hardware.sane.extraBackends = [pkgs.hplipWithPlugin pkgs.sane-airscan];
  services.udev.packages = [pkgs.sane-airscan];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
  ];

  services.ollama = with pkgs; {
    package = ollama-rocm;
    enable = true;
    acceleration = "rocm";
    rocmOverrideGfx = "11.0.1";
    environmentVariables = {
      HCC_AMDGPU_TARGET = "gfx1101"; # used to be necessary, but doesn't seem to anymore
    };
  };

  # allows for legacy apps to run on hyprland
  programs.xwayland.enable = true;

  programs.steam.enable = true;

  # hyprland
  programs.hyprland = {
    enable = true;
    # allow for legacy apps on hyprland (this might be the same as programs.xwayland.enable but I'm not sure)
    xwayland.enable = true;
  };

  # allows for screen capture to work in hyprland
  xdg.portal = {
    enable = true;
  };

  # target system version
  system.stateVersion = "24.11";

  # sound priority
  security.rtkit.enable = true; # this allows pipewire to handle real-time priority

  # sound
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true; # enable wireplumber commands
  };

  # important session/bash variables
  environment.sessionVariables = {
    # hyprland vars
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";

    # others
    EDITOR = "hx";

    # fixing these shitty dotfiles in my directory
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
  };

  # aliasing and some other bash-env
  environment.interactiveShellInit = ''
    alias less='bat'
    alias lsblk='lsblk -t -o RO,RM,HOTPLUG,NAME,SIZE,UUID,MODE,PATH,MODEL'
    alias dirs='dirs -v'
    alias rebuild='bash ~/.config/.scripts/rebuild.sh'
    alias nix-prefetch-hash-sha256='bash ~/.config/.scripts/nix-prefetch-hash-sha256.sh'
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

  # import the nix-user-repo
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
    # nur2 = import (builtins.fetchTarball "https://github.com/GimmeDataNow/nur/archive/master.tar.gz") {
    # inherit pkgs;
    # };
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
    ouch # universal unarchiver
    glow # markdown viewer
    bat # better pager and better cat

    alejandra # auto formatter for nix

    # gui
    hyprland
    pwvucontrol # audio control
    unstable.firefox # browser
    floorp
    rofi-wayland # app launcher
    waybar
    wev # get keyboard inputs
    dunst # notification manager
    swww # desktop background
    mpvpaper
    pavucontrol
    imv # terminal image viewer
    unstable.bitwarden-desktop # password manager
    sirikali # encryption manager
    qalculate-qt # calculator
    localsend # airdrop
    # screenshot and color pickers
    grim # grab area from wayland compositor
    slurp # mark an area from the wayland compositor
    swappy # save a buffer as an image
    hyprpicker # color picker for hyprland

    # code
    vscode.fhs # vscode
    nil # nix language server

    # personal
    unstable.xwaylandvideobridge # allows for screensharing
    unstable.freetube # better youtube desktop
    obs-studio # obs
    mpv # video playern
    nur.repos.nltch.spotify-adblock # spotify adblock
    # nur2.grayjay-desktop
    # nur2.example-package
    unstable.obsidian # notetaking
    anki # learning cards

    # communication
    stable.vesktop # discord
    xdg-utils # xdg-settings and more (set default browser)

    # gaming
    gamescope
    wineWowPackages.stable # additional packages for lutis (may not be needed)
    lutris # windows games on linux
    winetricks # execute this to fix wine
    heroic # heroic games launcher
    prismlauncher # minecraft

    # theme
    pkgs.adwaita-icon-theme # makes wm not crash
    lxappearance-gtk2 # icon theme changer
  ];
}
