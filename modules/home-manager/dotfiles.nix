{
  config,
  lib,
  ...
}: let
  cfg = config.modules.dotfiles;

  dotfiles = config.lib.file.mkOutOfStoreSymlink config.home.mutableFile."library/dotfiles".path;
in {
  options.modules.dotfiles = {
    enable = lib.mkOption {
      description = ''
        Whether to install dotfiles
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    home = {
      mutableFile."library/dotfiles" = {
        url = "https://github.com/diegofariasm/dotfiles.git";
        type = "git";
      };
    };
  };
}
