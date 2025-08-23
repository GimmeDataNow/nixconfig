{pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {
  shellHook = ''
  '';

  nativeBuildInputs = with pkgs.buildPackages; [
    i2p # i2p
    i2pd-tools # router info
    xd #torrent
  ];
}
