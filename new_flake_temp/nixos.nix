{ inputs, ... }:

{
  flake = {

    nixosConfigurations.mainpc = inputs.nix-stable-pkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./systems/mainpc/default.nix
        
        {
          _module.args = {
            # inherit inputs;
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
            # inherit inputs;
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
