{ inputs, config, pkgs, unstable, ...}: {
hardware.sane.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  hardware.sane.extraBackends = [
    # pkgs.hplipWithPlugin
    pkgs.sane-airscan
  ];
  services.udev.packages = [pkgs.sane-airscan];
}
