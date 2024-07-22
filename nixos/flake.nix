{
  description = "builds the system";
  
  inputs =  {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
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
        specialArgs = { inherit inputs outputs; };

        modules = [ 
          ./min-configuration.nix
          # ./freetube.nix
          # ./espanso.nix
         ];
      };
    };
  };
}
