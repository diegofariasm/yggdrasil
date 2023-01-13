{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.git;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.shell.git = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gitAndTools.git-annex
      gitAndTools.gh
      gitAndTools.git-open
      gitAndTools.diff-so-fancy
      act
    ];

    home.configFile = {
      "git/config".source = "${configDir}/git/config";
      "git/attributes".source = "${configDir}/git/attributes";
      "git/gitconfig-work".source = "${configDir}/git/gitconfig-work";
      "git/gitconfig-personal".source = "${configDir}/git/gitconfig-personal";
    };

  };
}
