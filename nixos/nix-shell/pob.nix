{pkgs ? import <nixos-unstable> {}}:
pkgs.mkShell {
  shellHook = ''
    alias pob="pobfrontend"
    echo "path of building is now avaliable"
  '';

  nativeBuildInputs = with pkgs.buildPackages; [
    path-of-building
  ];
}
