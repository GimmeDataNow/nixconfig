{ pkgs, ...}: {
hardware.sane.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  hardware.sane.extraBackends = [
    pkgs.sane-airscan
  ];
  services.udev.packages = [ pkgs.sane-airscan ];
}
