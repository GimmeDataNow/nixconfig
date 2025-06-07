{ pkgs, unstable, ...}: {
  nixpkgs.config.packageOverrides = pkgs: {
    nur =
      import (builtins.fetchGit {
        url = "https://github.com/NL-TCH/nur-packages.git";
        ref = "master";
        rev = "d7c48ab53778bb9c63458c797d8f2db0a57f191c";
      }) {
        inherit pkgs;
      };
  };
  environment.systemPackages = with pkgs; [
    # tui/cli
    kitty # terminal emulator
    tmux # terminal multiplexer
    vim # basic text editor
    unstable.helix # vim alternative in rust
    xclip # clipboard manager for files
    git # git
    pipewire # audio system
    wireplumber # manager for the audio system
    ranger # tui file explorer
    unstable.yazi # tui file explorer
    trash-cli # yazi restore deleted files
    exiftool # yazi preview exif data of audio files
    btop # system monitor
    unzip # unzip
    wl-clipboard # fixes the clipboard for wayland
    playerctl # media controller
    starship # better bash prompt
    ouch # universal unarchiver
    glow # markdown viewer
    bat # better pager and better cat
    bashmount # easier usb mounting

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
    kdePackages.xwaylandvideobridge
    unstable.freetube # better youtube desktop
    obs-studio # obs
    mpv # video playern
    # nur.spotify-adblock # spotify adblock
    unstable.obsidian # notetaking
    anki # learning cards

    # communication
    vesktop # discord
    xdg-utils # xdg-settings and more (set default browser)

    # gaming
    steam
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
  nixpkgs.config.permittedInsecurePackages = [
    "electron-33.4.11"
  ];
}
