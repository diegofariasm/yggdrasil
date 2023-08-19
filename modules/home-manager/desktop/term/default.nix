{ config
, lib
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.term;
in
{
  options.modules.desktop.term = {
    default = {
      name = mkOpt types.str "xterm";
      command = mkOpt types.str "xterm";
    };
  };

  config = {

    env = {
      TERMINAL = cfg.default.name;
      TERMINAL_COMMAND = cfg.default.command;
    };
  };
}
