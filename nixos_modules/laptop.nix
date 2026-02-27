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
      libcamera
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

    systemd.services.usbwakeup = {
      script = buildits.readfile ../hosts/nixos-surface/allow_wakeup.sh;
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
