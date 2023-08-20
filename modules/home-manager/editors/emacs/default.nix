{ config, options, lib, pkgs, ... }:

let
  cfg = config.modules.editors.emacs;
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
    # Install the emacs binary
    home.packages = with pkgs; [
      fd
      ripgrep
      marksman
      shellcheck
      # There should be no need to install the emacs
      # package manually. The lines below should provide
      # the binary.
      ((emacsPackagesFor emacs).emacsWithPackages (epkgs: [
        epkgs.vterm
      ]))
    ];

    # Easier calling of emacs on the command line.
    # You should probably have the daemon running anyway.
    programs.zsh.shellAliases = {
      emacs = "emacsclient -c -a 'emacs'";
    };

  };
}
