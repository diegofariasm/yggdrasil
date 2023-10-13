{ config
, lib
, ...
}:
with lib;
 let
  cfg = config.modules.editors;
in
{
  options.modules.editors = {
    default = {
      bin = mkOpt types.str "vim";
      args = mkOption {
        default = null;
        type = types.nullOr (types.listOf types.str);
        description = "A list of strings representing arguments";
      };
      about = mkOpt types.str "The default editor.";
    };

  };

  config = lib.mkIf (cfg.default != null) {
    maiden = {
      launch = {
        editor = {
          bin = cfg.default.bin;
          args = cfg.default.args;
          about = cfg.default.about;
        };
      };
    };
  };

}

