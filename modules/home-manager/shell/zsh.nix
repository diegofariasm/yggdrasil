{
  config,
  lib,
  ...
}: let
  cfg = config.modules.shell.zsh;
in {
  options.modules.shell.zsh = {
    enable = lib.mkOption {
      description = ''
        Whether to enable the zsh shell.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      programs.zsh.enable = true;
    }
    (lib.mkIf config.modules.roots.enable {
      home.file = {
        ".zshrc".source = "${config.modules.roots.directory}/.zshrc";
      };

      xdg.configFile = {
        zsh.source = "${config.modules.roots.directory}/.config/zsh";
      };
    })
  ]);
}
