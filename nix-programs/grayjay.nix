{
  pkgs,
  lib,
  stdenvNoCC,
  makeDesktopItem,
  makeShellWrapper,
  copyDesktopItems,
  electron,
  nixosTests,
  fetchzip,
}: let
  description = "Downloads the zip from https://updater.grayjay.app/Apps/Grayjay.Desktop/Grayjay.Desktop-linux-x64.zip by hovering over the linkts at https://grayjay.app/desktop/";
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "grayjay";
    # versioncode.updaterversion(without the v).versiontype
    # pulled from the application by going to Setting>Info and reading the relevant data
    version = "6.2.stable";

    src = fetchzip {
      url = "https://updater.grayjay.app/Apps/Grayjay.Desktop/Grayjay.Desktop-linux-x64.zip";
      sha256 = "9dKsw1SjWGMxeexwhJX39if3DfnClCOzSSa/ul13Zxc=";
      stripRoot = false;
    };

    srcName = "Grayjay.Desktop-linux-x64-v6";

    nativeBuildInputs = [
      makeShellWrapper
      copyDesktopItems
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/lib/grayjay
      # cp -r $src/* $out/lib/grayjay
      for file in Grayjay.Desktop-linux-x64-v6/*; do
        echo file
        if [ "$(basename "$file")" != "Portable" ]; then
          cp -r "$file" $out/lib/grayjay
        fi
      done

      # chmod +w $out/lib/grayjay/Grayjay.Desktop-linux-x64-v6/Grayjay
      # rm $out/lib/grayjay/Grayjay.Desktop-linux-x64-v6/Portable

      echo $out
      # rm $out/lib/grayjay/Grayjay.Desktop-linux-x64-v6/Grayjayc/Portable

      mkdir -p $out/bin

      # Set LD_LIBRARY_PATH to match your FHS shell runtime deps
      makeWrapper $out/lib/grayjay/Grayjay $out/bin/grayjay \
      --set XDG_DATA_HOME "~/.local/share" \
      --set XDG_CACHE_HOME "~/.cache" \
      --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath [
        pkgs.libz
        pkgs.icu
        # pkgs.openssl
        pkgs.xorg.libX11
        pkgs.xorg.libXcomposite
        pkgs.xorg.libXdamage
        pkgs.xorg.libXext
        pkgs.xorg.libXfixes
        pkgs.xorg.libXrandr
        pkgs.xorg.libxcb
        # pkgs.gtk3
        # pkgs.glib
        # pkgs.nss
        # pkgs.nspr
        pkgs.dbus
        pkgs.atk
        pkgs.cups
        pkgs.libdrm
        pkgs.expat
        pkgs.libxkbcommon
        pkgs.pango
        pkgs.cairo
        pkgs.udev
        # pkgs.alsa-lib
        # pkgs.mesa
        pkgs.libGL
        pkgs.libsecret
      ]}" \

      # Optionally install icon
      # mkdir -p $out/share/icons/hicolor/512x512/apps
      # cp $src/grayjay.png $out/share/icons/hicolor/512x512/apps/grayjay.png

      runHook postInstall
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "grayjay";
        desktopName = "Grayjay";
        comment = description;
        exec = "Grayjay %U"; # TODO figure out what %U does
        terminal = false;
        type = "Application";
        icon = "grayjay.png"; # TODO figure out how icons work
        startupWMClass = "Grayjay";
        # mimeTypes = [ "x-scheme-handler/freetube" ];
        categories = ["Network"];
      })
    ];

    passthru.tests = nixosTests.grayjay;

    meta = {
      inherit description;
      homepage = "https://grayjay.app/";
      license = lib.licenses.gpl2;
      maintainers = with lib.maintainers; [
        # todo
      ];
      badPlatforms = [
        # TODO implement other systems
        #see: https://github.com/NixOS/nixpkgs/pull/384596#issuecomment-2677141349
        lib.systems.inspect.patterns.isDarwin
      ];
      inherit (electron.meta) platforms;
      mainProgram = "grayjay";
    };
  })
