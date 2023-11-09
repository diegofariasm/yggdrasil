{ config, lib, ... }:

with lib;
let
  cfg = config.modules.desktop.term;
in
{
  options.modules.desktop.term = {
    default = {
      bin = mkOpt types.str "xterm";
      args = mkOption {
        default = null;
        type = types.nullOr (types.listOf types.str);
        description = "A list of strings representing arguments";
      };
      about = mkOpt types.str "The default terminal emulator.";
    };
  };

  config = {
    maiden.launch.term = {
      bin = cfg.default.bin;
      args = cfg.default.args;
      about = cfg.default.about;
    };
  };
}
