{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.fish;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.shell.fish = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fasd # Necessary for plugin    

    ];

    home.programs.exa = {
      enable = true;
      enableAliases = true;
    };

    home.programs.starship = {
      enable = true;
      enableFishIntegration = true;

    };
    programs.fish.enable = true;
    home.programs.fish = {
      enable = true;
      plugins = [
        {
          name = "z";
          src = pkgs.fetchFromGitHub {
            owner = "jethrokuan";
            repo = "z";
            rev = "ddeb28a7b6a1f0ec6dae40c636e5ca4908ad160a";
            sha256 = "0c5i7sdrsp0q3vbziqzdyqn4fmp235ax4mn4zslrswvn8g3fvdyh";
          };
        }

        # oh-my-fish plugins are stored in their own repositories, which
        # makes them simple to import into home-manager.
        {
          name = "fasd";
          src = pkgs.fetchFromGitHub {
            owner = "oh-my-fish";
            repo = "plugin-fasd";
            rev = "38a5b6b6011106092009549e52249c6d6f501fba";
            sha256 = "06v37hqy5yrv5a6ssd1p3cjd9y3hnp19d3ab7dag56fs1qmgyhbs";
          };
        }
        {
          name = "replay";
          src = pkgs.fetchzip {
            url = "https://github.com/jorgebucaran/replay.fish/archive/master.tar.gz";
            sha256 = "bM6+oAd/HXaVgpJMut8bwqO54Le33hwO9qet9paK1kY=";

          };

        }
        {
          name = "upto";
          src = pkgs.fetchzip {

            url = "https://github.com/Markcial/upto/archive/master.tar.gz";
            sha256 = "bM6+oAd/HXaVgpJMut8bwqO54Le33hwO9qet9paK1kY=";
          };
        }


      ];
    };

    users.defaultUserShell = pkgs.fish;
  };
}
