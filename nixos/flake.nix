{
  description = "builds the system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    xremap-flake.url = "github:xremap/nix-flake";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};

        modules = [
          ./configuration.nix
          # ./espanso-capdacoverride
          # ./freetube.nix
        ];
      };
    };
  };
}
