{ pkgs, ...}: {
  fonts.packages = with pkgs; [
    # nerdfonts # nerdfonts is a massive package but I dont care
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-mono
    nerd-fonts.ubuntu-sans
  ];
  fonts.fontconfig.defaultFonts = {
    serif = ["UbuntuMono Nerd Font"];
    sansSerif = ["UbuntuSansMono Nerd Font"];
    monospace = ["UbuntuMono Nerd Font Mono"];
  };
}
