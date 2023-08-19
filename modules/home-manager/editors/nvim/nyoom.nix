{ config, lib, ... }:

let
  cfg = config.modules.editors.nvim.nyoom;
in
{
  options.modules.editors.nvim.nyoom = {
    enable = lib.mkOption {
      description = ''
        Wheter to enable my nyoom.nvim config.

        Take note you have to install nvim to be able to use this.
        I won't do so because i trust you have the nvim binary.

        You do, right?!
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {

    home.mutableFile = {
      ".config/nvim" = {
        url = "https://github.com/fushiii/nyoom.nvim";
        type = "git";
      };
    };

    # Nyoom bin
    home.sessionPath = [
      "~/.config/nvim/bin"
    ];

  };
}
