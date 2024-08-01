{ pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {

  shellHook = ''
    alias run="npm run dev"

    echo "You are now in an astro shell"
    echo "Additional packages are: nodejs_21"
    echo "Currently in $(pwd)"
  '';

  nativeBuildInputs = with pkgs.buildPackages; [
    nodejs_22
  ];
}
