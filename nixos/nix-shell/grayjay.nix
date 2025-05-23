{pkgs ? import (fetchTarball {
  url = "https://github.com/NixOS/nixpkgs/archive/72841a4a8761d1aed92ef6169a636872c986c76d.tar.gz";
})

 {}}:
(pkgs.buildFHSEnv {
  name = "fhs";
  targetPkgs = _:
    with pkgs; [
      libz
      icu
      openssl # For updater

      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      xorg.libxcb

      gtk3
      glib
      nss
      nspr
      dbus
      atk
      cups
      libdrm
      expat
      libxkbcommon
      pango
      cairo
      udev
      alsa-lib
      mesa
      libGL
      libsecret
    ];
})
.env
