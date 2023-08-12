{ options
, config
, lib
, pkgs
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
    # Set these variables for later use.
    # TERMINAL --> the default terminal name
    # TERMINAL_COMMAND --> the default command for running the terminal.

    # Example values:
    # TERMINAL --> kitty
    # TERMINAL_COMMAND --> kitty --single-instance

    env = {
      TERMINAL = cfg.default.name;
      TERMINAL_COMMAND = cfg.default.command;
    };
  };
}
