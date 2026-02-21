{
  description = "My Unified NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11"; # Your stable base
    unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # The "bleeding edge" branch
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # inputs = {
        # nixpkgs.follows = "nixpkgs";
      # };
    };
    
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, unstable, ... }@inputs: 
  let
    inherit (self) outputs;
    user = "yourusername";
    
    # Define the helper function
    mkSystem = { host, system ? "x86_64-linux" }: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { 
        inherit inputs outputs user;
        # This makes 'unstable' available as an argument in every module
        unstable = import inputs.unstable {
          inherit system;
          config = { 
            allowUnfree = true; 
            allowInsecure = true; 
            allowBroken = true; 
          };
        };
      };
      modules = [ ./hosts/${host}/configuration.nix ];
    };

  in {
    nixosConfigurations = {
      desktop = mkSystem { host = "desktop"; };
      laptop = mkSystem { host = "laptop"; };
      minipc = mkSystem { host = "minipc"; };
      vps    = mkSystem { host = "vps"; };
    };
  };
}
