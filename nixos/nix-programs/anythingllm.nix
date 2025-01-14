{
  pkgs ? import <nixpkgs> {system = builtins.currentSystem;},
  stdenv ? pkgs.stdenv,
  lib ? pkgs.lib,
  fetchurl ? pkgs.fetchurl,
  appimageTools ? pkgs.appimageTools,
  makeWrapper ? pkgs.makeWrapper,
}:
stdenv.mkDerivation rec {
  pname = "anythingllm-desktop";
  version = "unstable";

  src = fetchurl {
    url = "https://cdn.useanything.com/latest/AnythingLLMDesktop.AppImage";
    hash = "sha256-hWCH4CTkpY0B8oyW/RA5uX0OAha2X2KcUEOd4VsX12c=";
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [makeWrapper];

  appimageContents = appimageTools.extractType2 {inherit pname version src;};

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/${pname} $out/share/applications

    cp ${src} $out/bin/${pname}
    chmod +x $out/bin/${pname}

    cat <<INI > $out/share/applications/${pname}.desktop
    [Desktop Entry]
    Terminal=true
    Name=${pname}
    Exec=$out/bin/${pname} %f
    Type=Application
    INI



    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=appimage.AppImage' "Exec=${pname}"

    runHook postInstall
  '';

  meta = {
    description = "Desktop application for AnythingLLM";
    homepage = "https://anythingllm.example.com/";
    license = lib.licenses.unfree; # Change this if a different license is applicable
    maintainers = with lib.maintainers; [
      yourmaintainername
    ];
  };
}
