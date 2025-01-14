{
  pkgs ? import <nixpkgs> {system = builtins.currentSystem;},
  stdenv ? pkgs.stdenv,
  lib ? pkgs.lib,
  fetchurl ? pkgs.fetchurl,
  appimageTools ? pkgs.appimageTools,
  makeWrapper ? pkgs.makeWrapper,
  electron ? pkgs.electron,
  nixosTests ? pkgs.nixosTests,
}:
stdenv.mkDerivation rec {
  pname = "anythingllm-desktop";
  version = "0.22.1";

  src = fetchurl {
    url = "https://cdn.useanything.com/latest/AnythingLLMDesktop.AppImage";
    hash = "sha256-hWCH4CTkpY0B8oyW/RA5uX0OAha2X2KcUEOd4VsX12c=";
  };

  appimageContents = appimageTools.extractType2 {inherit pname version src;};

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [makeWrapper];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname} $out/share/applications

    cp -a ${appimageContents}/{locales,resources} $out/share/${pname}
    cp -a ${appimageContents}/anythingllm-desktop.desktop $out/share/applications/${pname}.desktop

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'

    runHook postInstall
  '';

  # postFixup = ''
  #   makeWrapper ${electron}/bin/electron $out/bin/${pname}
  # '';

  meta = {
    description = "Open Source YouTube app for privacy";
    homepage = "https://freetubeapp.io/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      ryneeverett
    ];
    mainProgram = "freetube";
  };
}
