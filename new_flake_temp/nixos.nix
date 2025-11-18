{ inputs, ... }:

let
  system = "x86_64-linux";
in
{
  flake = {

    nixosConfigurations.mainpc = inputs.nix-stable-pkgs.lib.nixosSystem {
      # system = "x86_64-linux";
      inherit system;
      modules = [
        ./systems/mainpc/default.nix
        # inputs.spicetify-nix.nixosModules.spicetify
        ./modules/common/spicetify.nix
        
        {
          _module.args = {
            # spicetifyModule = inputs.spicetify-nix.nixosModules.spicetify;
            spicetifyLib = inputs.spicetify-nix.lib;
            spicePkgset = inputs.spicetify-nix.legacyPackages.${system};
            pkgsUnstable = import inputs.nix-unstable-pkgs {
              system = "x86_64-linux";
              config = {
                allowUnfree = true;
              };
            };
          };
        }
        
      ];
      
    };

    nixosConfigurations.minipc = inputs.nix-stable-pkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./systems/minipc/default.nix

        {
          _module.args = {
            pkgsUnstable = import inputs.nix-unstable-pkgs {
              system = "x86_64-linux";
              config = {
                allowUnfree = true;
              };
            };
          };
        }

      ];
    };

    nixosConfigurations.laptop = inputs.nix-stable-pkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./systems/laptop/default.nix

        {
          _module.args = {
            pkgsUnstable = import inputs.nix-unstable-pkgs {
              system = "x86_64-linux";
              config = {
                allowUnfree = true;
              };
            };
          };
        }

      ];
    };

  };
}
