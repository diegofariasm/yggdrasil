{ config, lib, ... }:

let
  cfg = config.modules.shell.direnv;
in
{
  options.modules.shell.direnv = {
    enable = lib.mkOption {
      description = ''
        Wheter to install the direnv package.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    programs.direnv = {
      # Helps my sanity all the time.
      # No need to get into a nix-shell for that, huh?
      enable = true;
      nix-direnv = {
        # Faster direnv.
        # Or atleast they so
        enable = true;
      };
    };
  };
}
