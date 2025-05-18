{
  description = "Main flake that decides which system to build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix/24.11";
  };

  outputs = {
    self,
    nixpkgs,
    unstable,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      mainpc = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          unstable = import <nixos-unstable> {};
        };

        modules = [
          ./mainpc/default.nix
        ];
      };
      minipc = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          unstable = import <nixos-unstable> {};
        };
        modules = [
          ./minipc/configuration.nix
        ];
      };
      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          unstable = import <nixos-unstable> {};
        };

        modules = [
          ./laptop/configuration.nix
        ];
      };
    };
  };
}
