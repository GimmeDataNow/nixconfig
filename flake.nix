{
  description = "Main flake that decides which system to build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    # spicetify-nix.url = "github:Gerg-L/spicetify-nix/df3f3ff6db7e1f553288592496f6293d32164d8a";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # inputs = {
        # nixpkgs.follows = "nixpkgs";
      # };
    };
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
          unstable = import inputs.unstable {
            config = {
              allowUnfree = true;
              allowInsecure = true;
              allowBroken = true;
            };
          };
        };

        modules = [
          ./minipc/default.nix
        ];
      };
      laptop = nixpkgs.lib.nixosSystem {
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
          ./laptop/default.nix
          inputs.spicetify-nix.nixosModules.default
        ];
      };
    };
  };
}
