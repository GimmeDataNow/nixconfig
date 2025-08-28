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
    starship # better bash prompt
    ouch # universal unarchiver
    glow # markdown viewer
    bat # better pager and better cat
    bashmount # easier usb mounting

    alejandra # auto formatter for nix

    localsend # airdrop

    nil # nix language server
    xdg-utils # xdg-settings and more (set default browser)
  ];
}
