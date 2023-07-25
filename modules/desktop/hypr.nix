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
  inherit (inputs) hyprland;

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

  imports = [
    hyprland.nixosModules.default
  ];

  config = mkIf cfg.enable
    {

      services.xserver = {
        enable = true;
        displayManager.gdm = {
          enable = true;
          autoSuspend = true;
        };
      };

      programs.hyprland.enable = true;
      user.packages = with pkgs; [
        dunst
        hyprpaper
        wl-clipboard-x11
        hyprpicker
        eww-wayland
        rofi-wayland
        configure-gtk
      ];
    };
}
