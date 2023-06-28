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
      run = mkOpt types.str "xterm";
      name = mkOpt types.str "xterm";
    };

  };

  config = {
    # Set these variables for later use.
    # TERMINAL --> the default terminal name
    # TERMINAL_RUN --> the default command for running the terminal.

    # Example values:
    # TERMINAL --> kitty
    # TERMINAL_RUN --> kitty --single-instance

    env = {
      TERMINAL = cfg.default.name;
      TERMINAL_RUN = cfg.default.run;
    };
  };
}
