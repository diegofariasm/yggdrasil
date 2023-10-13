{ config, lib, ... }:

with lib;
let 
cfg = config.modules.desktop.browsers;
in {
  options.modules.desktop.browsers = {
    default = {
      bin = mkOpt types.str "firefox";
      args = mkOption {
        default = null;
        type = types.nullOr (types.listOf types.str);
        description = "A list of strings representing arguments";
      };
      about = mkOpt types.str "The default browser";
    };
  };

  config = {
    maiden = {
      launch = {
        browser = {
          bin = cfg.default.bin;
          args = cfg.default.args;
          about = cfg.default.about;
        };
      };
    };
  };
}
