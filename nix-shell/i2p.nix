{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  shellHook = ''
  '';

  nativeBuildInputs = with pkgs; [
  ];

  buildInputs = with pkgs; [
    i2p
    i2pd
    i2pd-tools
    xd
  ];
}
