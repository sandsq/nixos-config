{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.touchscreen;
in
{
  options = {
    touchscreen = {
      enable = mkEnableOption "enable touchscreen things";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      libwacom
      libwacom-surface
      wvkbd
    ];
    services.iptsd = {
      enable = true;
      config = {
        Touchscreen.DisableOnStylus = true;
      };
    };
    # systemd.services.reenable_volume_buttons = {
    #   script = ''
    #     modprobe -r soc_button_array && modprobe soc_buttom_array
    #   '';
    #   wantedBy = [ "multi-user.target" ];
    # }; # https://github.com/linux-surface/linux-surface/issues/1392#issuecomment-1989558759
    boot.initrd.kernelModules = {
      pinctrl_sunrisepoint = true;
    };
  };
}
