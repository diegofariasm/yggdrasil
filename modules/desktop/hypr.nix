{ pkgs
, config
, inputs
, lib
, options
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.hypr;
  configDir = config.dotfiles.configDir;
  binDir = config.dotfiles.binDir; inherit (inputs) hyprland;

  # Needed for making gtk work properly on wayland
  configure-gtk = pkgs.writeTextFile {
    name = "configure-gtk";
    destination = "/bin/configure-gtk";
    executable = true;
    text =
      let
        schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in
      ''
        #!/usr/bin/env bash

        export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS

        available_options=(
        	icon
        	cursor
        	gtk
        )

        if [[ -z "$1" || -z "$2" ]]; then
        	echo "Improper usage: atleast 2 arguments are expected."
        	echo "Example usage: $0 gtk Dracula"
        else
            
            if [[ ''${available_options[*]} =~ (^|[[:space:]])"$1"($|[[:space:]]) ]]; then
                ${pkgs.glib}/bin/gsettings set org.gnome.desktop.interface "$1-theme" "$2"
        		exit 0
        	else
        		echo "Invalid option. Available options are:"
        		for option in "''${available_options[@]}"; do
        			echo "* $option"
        		done
        	fi
        fi
      
      '';
  };
in
{
  options.modules.desktop.hypr = { enable = mkBoolOpt false; };

  # The needed module
  imports = [
    hyprland.nixosModules.default
  ];

  config = mkIf cfg.enable {

    # Display manager
    services.xserver = {
      enable = true;
      # This will work properly with wayland, but not Xorg.
      displayManager.gdm = {
        enable = true;
        autoSuspend = true;
      };
    };

    programs.hyprland.enable = true;
    home.programs = {
      rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        plugins = with pkgs; [
          rofi-calc
        ];
      };

    };
    home.packages = with pkgs; [
      foot
      mako
      hyprpaper
      hyprpicker
      eww-wayland
      configure-gtk
    ];

    home.configFile = {
      "hypr" = {
        source = "${configDir}/hypr";
        recursive = true;
      };
      "hypr/scripts" = {
        source = "${binDir}/hypr";
      };
    };
  };
}
