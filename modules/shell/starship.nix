{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.starship;
in
{
  options.modules.shell.starship = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      starship
      my.icomoon
    ];
    modules.shell.zsh.rcInit = ''eval "$(starship init zsh)"'';
  };
}
