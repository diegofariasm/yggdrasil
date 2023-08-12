{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.git;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.shell.git = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      gitAndTools.gh
      gitAndTools.git-open
      gitAndTools.git-annex
      gitAndTools.diff-so-fancy
    ];

    home.configFile = {
      "git/config".source = "${configDir}/git/config";
      "git/gitconfig-work".source = "${configDir}/git/gitconfig-work";
      "git/gitconfig-personal".source = "${configDir}/git/gitconfig-personal";
    };

    modules.shell.zsh.rcFiles = [ "${configDir}/git/aliases.zsh" ];
  };
}
