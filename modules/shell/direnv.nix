{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.direnv;
in
{
  options.modules.shell.direnv = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      direnv
    ];
    modules.shell.zsh.rcInit = ''eval "$(direnv hook zsh)"'';
  };
}
