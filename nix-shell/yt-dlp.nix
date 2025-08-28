{pkgs ? import <nixos-unstable> {}}:
pkgs.mkShell {
  shellHook = ''
  '';

  nativeBuildInputs = with pkgs.buildPackages; [
    yt-dlp
  ];
}
