{
  description = "Main flake that decides which system to build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs = {
    self,
    nixpkgs,
    # unstable,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      mainpc = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          unstable = import inputs.unstable {
            config = {
              allowUnfree = true;
              allowInsecure = true;
              allowBroken = true;
            };
          };
        };

        modules = [
          ./mainpc/default.nix
          inputs.spicetify-nix.nixosModules.default
        ];
      };
      minipc = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          unstable = import inputs.unstable {};
        };
        modules = [
          ./minipc/configuration.nix
        ];
      };
      laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs;
          unstable = import inputs.unstable {};
        };

        modules = [
          ./laptop/configuration.nix
        ];
      };
    };
  };
}
