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
    home.sessionVariables = with cfg.default; {
      TERMINAL = name;
      TERMINAL_COMMAND = command;
    };
  };
}
