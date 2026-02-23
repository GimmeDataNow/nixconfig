{ pkgs, ... }: 
let
  # Fetch the plugin source via Nix
  ouch-yazi = pkgs.fetchFromGitHub {
    owner = "ndtoan96";
    repo = "ouch.yazi";
    rev = "c2a48b99920f4b35084f9fb57b8c2c9975e7289b"; # Or use a specific commit hash
    hash = "sha256-TA7V9KsiqV/j0/v+lrqKMVKgWTCQ/4ddWj6ven8G22k="; # Run 'nix-prefetch-url' or let Nix fail once to get the hash
  };
in {
  # ouch.yazi requires the 'ouch' binary to be in your PATH
  home.packages = [ pkgs.ouch ];

  programs.yazi = {
    enable = true;

    # 1. Install the plugin
    plugins = {
      ouch = "${ouch-yazi}";
    };

    # 2. Add the Previewer and Opener settings (yazi.toml)
    settings = {
      plugin = {
        prepend_previewers = [
          {
            mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
            run = "ouch --show-file-icons";
          }
        ];
      };
      opener = {
        extract = [
          { 
            run = ''ouch d -y "$@"''; 
            desc = "Extract here with ouch"; 
            for = "unix"; 
          }
        ];
      };
    };

    # 3. Add the Compression keymap (keymap.toml)
    keymap.manager.prepend_keymap = [
      {
        on = [ "C" ];
        run = "plugin ouch";
        desc = "Compress with ouch";
      }
    ];
  };
}
