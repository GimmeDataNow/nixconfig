{ pkgs ? import <nixpkgs> {}}:
pkgs.mkShell {

  shellHook = ''
      export GDK_BACKEND=x11
  '';

  nativeBuildInputs = with pkgs; [
    pkg-config
    gobject-introspection
    cargo
    cargo-tauri
    nodejs
    rustc
  ];

  buildInputs = with pkgs;[
    at-spi2-atk
    atkmm
    cairo
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    librsvg
    libsoup_3
    pango
    webkitgtk_4_1
    openssl
  ];

}
