{
  description = "A collection of programs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    lazap.url = "github:Lazap-Development/Lazap";
  };

  outputs = { self, nixpkgs }: 
  let pgks = nixpkgs.legacyPackages.x86_64-linux;
  in {

    packages.x86_64-linux.lazap = nixpkgs.callPackage ./lazap.nix { };

    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

  };
}
