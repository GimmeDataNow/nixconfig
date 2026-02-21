{ user, ... }: {
  home.sessionVariables = {
    EDITOR = "hx";
    # XDG Cleanliness
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    # App specific
    CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    NLTK_DATA = "/home/${user}/.cache/nltk";
  };

  # Home Manager has a dedicated way to handle aliases
  home.shellAliases = {
    less = "bat";
    lsblk = "lsblk -t -o RO,RM,HOTPLUG,NAME,SIZE,UUID,MODE,PATH,MODEL";
    dirs = "dirs -v";
    rebuild = "bash ~/.config/.scripts/rebuild.sh";
    nix-prefetch-hash-sha256 = "bash ~/.config/.scripts/nix-prefetch-hash-sha256.sh";
    bm = "bashmount";
  };

  # Custom functions go here
  programs.bash.initExtra = ''
    # Yazi cwd jump
    function y() {
      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
      yazi "$@" --cwd-file="$tmp"
      if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
      fi
      rm -f -- "$tmp"
    }

    gitlog() {
      git log --oneline --graph --decorate --all
    }

    timer() {
      SECONDS=0
      "$@"
      duration=$SECONDS
      echo "⏱️ Time: $((duration / 60))m $((duration % 60))s"
    }
  '';
}
