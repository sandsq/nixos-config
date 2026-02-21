{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.laptop;
in
{
  options = {
    laptop = {
      enable = mkEnableOption "enable laptop things";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      acpi
      brightnessctl
    ];
    # Enable touchpad support (enabled default in most desktopManager).
    services.libinput.enable = true;
    services.libinput.touchpad.disableWhileTyping = false;

    # services.power-profiles-daemon.enable = true;
    services.upower.enable = true;
    services.logind.settings.Login = {
      HandlePowerKey = "suspend";
      HandlePowerKeyLongPress = "poweroff";
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
    systemd.services.usbwakeup = {
      script = ''
        echo enabled > /sys/bus/usb/devices/1-5/power/wakeup
        echo enabled > /sys/bus/usb/devices/1-7/power/wakeup
        echo enabled > /sys/bus/usb/devices/2-4/power/wakeup
        echo enabled > /sys/bus/usb/devices/usb1/power/wakeup
        echo enabled > /sys/bus/usb/devices/usb2/power/wakeup
      '';
      wantedBy = [ "multi-user.target" ];
    };
    services.thermald.enable = true;
    services.tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        START_CHARGE_THRESH_BAT1 = "40";
        STOP_CHARGE_THRESH_BAT1 = "80";
      };
    };
  };
}
