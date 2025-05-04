{
  description = "Main flake that decides which system to build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    nixosConfigurations = {
      # nixos = nixpkgs.lib.nixosSystem {
        # specialArgs = {inherit inputs outputs;};

        # modules = [
          # ./configuration.nix
        # ];
      # };
      mainpc = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};

        modules = [
          ./mainpc/configuration.nix
        ];
      };
      minipc = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};

        modules = [
          ./minipc/configuration.nix
        ];
      };
    };
  };
}
