{ pkgs, ... }:
let
  nnnPluginsSrc = pkgs.fetchFromGitHub {
    owner = "jarun";
    repo = "nnn";
    rev = "v5.2"; # match your nnn package version
    hash = "sha256-u+88aDHfOZ6bSkg6ahS6eNZWj2QCwJXKW+8nHR99kic="; # leave blank, fill in from the build-failure hash on first switch
  };
in {
  home.packages = with pkgs; [
    ouch
    file
    ffmpegthumbnailer
    mediainfo
    chafa
  ];

  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override { withNerdIcons = true; };
    quitcd = true;

    bookmarks = {
      l = "~/.local";
      n = "~/nixos";
      p = "~/secondary_drive";
      u = "~/usb";
      d = "~/downloads";
      c = "~/.config";
      h = "~";
    };

    plugins = {
      src = "${nnnPluginsSrc}/plugins";
      mappings = {
        p = "preview-tui";
        x = "_extract";
        c = "_chksum";
      };
    };
  };

  programs.bash.initExtra = ''
    export NNN_FIFO="/tmp/nnn-fifo.$$"
  '';
}
