{ ... }: {
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
    HYPRSHOT_DIR = "$HOME/screenshots";

    NLTK_DATA="/home/hallow/.cache/nltk";
  };

  # aliasing
  environment.interactiveShellInit = ''
    alias less='bat'
    alias lsblk='lsblk -t -o RO,RM,HOTPLUG,NAME,SIZE,UUID,MODE,PATH,MODEL'
    alias dirs='dirs -v'
    alias rebuild='bash ~/.config/.scripts/rebuild.sh'
    alias nix-prefetch-hash-sha256='bash ~/.config/.scripts/nix-prefetch-hash-sha256.sh'
    alias bm='bashmount'
  ''
  + # auto enter current directory after qutting using yazi
  ''
    function y() {
      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
      yazi "$@" --cwd-file="$tmp"
      if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      builtin cd -- "$cwd"
      fi
      rm -f -- "$tmp"
    }
  ''
  + # scroll trough git commits
  ''
    gitlog() {
      git log --oneline --graph --decorate --all
    }
  ''
  + # time the following command
  ''
    timer() {
      SECONDS=0
      "$@"
      duration=$SECONDS
      echo "⏱️ Time: $((duration / 60))m $((duration % 60))s"
    }
  '';
}
