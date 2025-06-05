{ ... }:
{
  services.xserver.videoDrivers = ["amdgpu"]; # gpu driver
  hardware.graphics.enable = true; # enable hardware accelerated graphics drivers
  hardware.graphics.enable32Bit = true; # on 64-bit systems, whether to also install 32-bit drivers for 32-bit applications (such as Wine)
  programs.xwayland.enable = true; # whether to enable Xwayland (an X server for interfacing X11 apps with the Wayland protocol) 
  xdg.portal.enable = true; # whether to enable xdg desktop integration
  programs.hyprland = {
    enable = true; # whether to enable Hyprland
    xwayland.enable = true; # whether to enable XWayland.
  };
}
