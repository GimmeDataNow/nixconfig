{
  description = "The entry file for my nixos config";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-stable-pkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nix-unstable-pkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./nixos.nix
      ];
      systems = [ "x86_64-linux" "aarch64-linux" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {

      };
    };
}
