{ config, lib, ... }:
with lib;
let
  cfg = config.modules.desktop.apps.files;
in
{
  options.modules.desktop.apps.files = {
    default = {
      bin = lib.my.mkOpt types.str "thunar";
      args = mkOption {
        default = null;
        type = types.nullOr (types.listOf types.str);
        description = "A list of strings representing arguments";
      };
      about = lib.my.mkOpt types.str "The default file manager";
    };
  };

  config = {
    maiden.launch.files = {
      bin = cfg.default.bin;
      args = cfg.default.args;
      about = cfg.default.about;
    };
  };
}
