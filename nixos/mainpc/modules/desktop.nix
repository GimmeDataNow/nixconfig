{ imports, pkgs, unstable, config, ... }:
{
  services.xserver.videoDrivers = ["amdgpu"]; # use nvidia, this is critical for hyprland
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  programs.xwayland.enable = true;
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  xdg.portal = {
    enable = true;
  };
}
