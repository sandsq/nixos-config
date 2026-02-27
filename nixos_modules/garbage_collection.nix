{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.garbage_collection;
in
{

  options = {
    garbage_collection = {
      enable = mkEnableOption "enables garbage_collection";
      configuration_limit = mkOption {
        type = types.int;
        default = 20;
      };
      frequency = mkOption {
        type = types.str;
        default = "weekly";
      };
      extra_args = mkOption {
        type = types.str;
        default = "--delete-older-than 7d";
      };
      auto_optimize_store = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };
  config = lib.mkIf config.garbage_collection.enable {
    boot.loader.systemd-boot = {
      configurationLimit = cfg.configuration_limit;
    };

    nix.gc = {
      automatic = true;
      dates = cfg.frequency;
      options = cfg.extra_args;
    };

    nix.settings.auto-optimise-store = cfg.auto_optimize_store;
  };
}
