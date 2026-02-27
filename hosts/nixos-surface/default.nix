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
  laptop.enable = true;
  laptop.allow_wakeup_script_path = ./allow_wakeup.sh;
  touchscreen.enable = true;
  obs.enable = true;
  steam.enable = true;

  #     run ln -sf /home/sand/nixos-config/dotfiles/eww /home/sand/.config/eww
  system.activationScripts = {
    symlink_eww = {
      text = ''
        ln -sfn /home/sand/nixos-config/dotfiles/eww /home/sand/.config/eww
      '';
    };
  };
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot = {
    enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.microsoft-surface = {
    kernelVersion = "stable";
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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sand = {
    isNormalUser = true;
    home = "/home/sand";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
    ];
    shell = pkgs.bash;
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    gh # seems like gh needs to be here otherwise the auth won't be remembered
  ];

  # security.rtkit.enable = true;
  # xdg.autostart.enable = true;
  # xdg.portal = {
  #   enable = true;
  #   extraPortals = [
  #     pkgs.xdg-desktop-portal
  #     pkgs.xdg-desktop-portal-hyprland
  #     pkgs.xdg-desktop-portal-gtk
  #   ];
  #   # xdgOpenUsePortal = true;
  #   config = {
  #     common = {
  #       default = [ "gtk" ];
  #       "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
  #     };
  #     hyprland = {
  #       default = [
  #         "hyprland"
  #         "gtk"
  #       ];
  #       "org.freedesktop.portal.FileChooser" = [ "gtk" ];
  #       "org.freedesktop.portal.OpenURI" = [ "gtk" ];
  #     };
  #   };
  # };

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
