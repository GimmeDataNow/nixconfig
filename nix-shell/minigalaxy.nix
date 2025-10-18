{
  description = "FHS-compatible environment for GOG games with Minigalaxy";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      packages.${system}.default = pkgs.buildFHSEnv {
        name = "gog-env";

        # ✅ All required 64-bit runtime deps + Minigalaxy
        targetPkgs = pkgs: with pkgs; [
          minigalaxy
          SDL2
          openal
          vulkan-loader
          alsa-lib
          pulseaudio
          gtk3
          glib
          libGL
          xorg.libX11
          xorg.libXext
          xorg.libXrandr
          xorg.libXcursor
          xorg.libXi
          freetype
          fontconfig
          zlib
        ];

        # ✅ Required 32-bit libraries for older GOG games
        multiPkgs = pkgs: with pkgs; [
          SDL2
          openal
          alsa-lib
          glib
          gtk3
          libGL
          xorg.libX11
          xorg.libXext
          xorg.libXrandr
          xorg.libXcursor
          xorg.libXi
          freetype
          fontconfig
          zlib
        ];

        # ✅ Automatically run Minigalaxy inside this env
        runScript = "minigalaxy";
      };

      # Optional: devShell to use `nix develop` for debugging
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [
          pkgs.minigalaxy
        ];
      };
    };
}
