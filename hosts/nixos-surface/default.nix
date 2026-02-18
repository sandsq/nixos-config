{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ../../nixos_modules
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  garbage_collection.enable = true;
  cachix_for_hyprland.enable = true;
  dvorak.enable = true;
  thunar.enable = true;
  sound_module.enable = true;
  bluetooth_module.enable = true;
  fonts.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.microsoft-surface = {
    kernelVersion = "stable";
  };
  services.iptsd = {
    enable = true;
    config = {
      Touchscreen.DisableOnStylus = true;
    };
  };

  fileSystems."/mnt/sd256" = {
    device = "/dev/disk/by-uuid/2408d4f6-1793-452c-81b0-554064c097ea";
    fsType = "ext4";
    options = [
      "defaults"
      "noatime"
    ];
  };

  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; # need for file picker
    # config = {
    #   preferred = {
    #     default = [ "hyprland" ];
    #     "org.freedesktop.impl.portal.FileChooser" = [
    #       "gtk"
    #     ];
    #   };
    # };
    config = {
      hyprland.default = [
        "hyprland"
        "gtk"
      ];
      hyprland."org.freedesktop.portal.FileChooser" = [ "gtk" ];
      hyprland."org.freedesktop.portal.openURI" = [ "gtk" ];
    };
  };

  networking.hostName = "nixos-surface"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "America/Indianapolis";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.upower.enable = true;
  # services.power-profiles-daemon.enable = true;

  # so signins persist or something (like zed)
  services.gnome.gnome-keyring.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.libinput.touchpad.disableWhileTyping = false;
  # Define a user account. Don't forget to set a password with ‘passwd’.

  users.users.sand = {
    isNormalUser = true;
    home = "/home/sand";
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.bash;
  };
  # programs.bash = {
  #   interactiveShellInit = ''
  #     if grep -qv 'fish' /proc/$PPID/comm && [[ ${SHLVL} == [1,2] ]]
  #     then
  #      	shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=''
  #      	exec fish $LOGIN_OPTION
  #     fi
  #   '';
  # };
  # programs.fish.enable = true;

  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # fuzzel
    wl-clipboard
    gh
    eww
    zed-editor
    tree
    libwacom
    libwacom-surface
    killall
    jq
    brightnessctl
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    quickshell
    kdePackages.qtwayland
    kdePackages.qtsvg
    kdePackages.qtimageformats
    kdePackages.qtmultimedia
    kdePackages.qt5compat
    acpi
    nil
    nixd
    package-version-server
    socat
    libnotify
    dunst
    dracula-icon-theme
    wvkbd
    bc
    libinput
    dropbox
    dconf-editor
    fastfetch
  ];

  programs.steam.enable = true;

  programs.obs-studio.enable = true;

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
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
