{ pkgs ? import <nixos-unstable> {}}:
pkgs.mkShell {

  shellHook = ''
    alias start="sudo espanso service start --unmanaged"
    echo "espanso is now avaliable"
  '';

  nativeBuildInputs = with pkgs.buildPackages; [
    espanso-wayland
  ];
}
