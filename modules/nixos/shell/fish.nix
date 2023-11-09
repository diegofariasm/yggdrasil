{ pkgs, config, inputs, lib, ... }:

let
  cfg = config.modules.shell.fish;
in
{
  options.modules.shell.fish = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
    };
    users.defaultUserShell = pkgs.fish;

  };
}
