{
  description = "My Unified NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05"; # The stable branch
    unstable.url = "github:nixos/nixpkgs/nixos-unstable"; # The "bleeding edge" branch

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";

      # url = "github:nix-community/home-manager/master";
      # inputs.nixpkgs.follows = "unstable";
    };

    # zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        # IMPORTANT: To ensure compatibility with the latest Firefox version, use nixpkgs-unstable.
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # zed-editor.url = "github:zed-industries/zed";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    
    sops-nix.url = "github:Mic92/sops-nix";
  };

  outputs = { self, nixpkgs, unstable, ... }@inputs: 
  let
    inherit (self) outputs;
    user = "hallow";
    
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
            permittedInsecurePackages = [
              "electron-39.8.10"
            ];
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
