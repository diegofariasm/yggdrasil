{ config, pkgs, lib, ... }:

let cfg = config.modules.editors.emacs;
in
{
  options.modules.editors.emacs = {
    enable = lib.mkOption {
      description = ''
        Wheter to install emacs.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {

    programs.emacs = {
      enable = true;
      extraPackages = epkgs: with epkgs; [
        vterm
      ];
    };

    services.emacs = {
      enable = true;
      client = {
        enable = true;
        # clientArguments = [
        #   # TODO  
        # ];
      };
      startWithUserSession = true;
      socketActivation.enable = true;
    };

    # Dependencies for emacs ( doom )
    home.packages = with pkgs; [ fd ];

    # Easier calling of emacs on the command line.
    # You should probably have the daemon running anyway.
    programs.zsh.shellAliases = { emacs = "emacsclient -c -a 'emacs'"; };

  };
}
