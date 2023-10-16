{ pkgs, config, inputs, lib, ... }:


let
  cfg = config.modules.desktop.hyprland;
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
  options.modules.desktop.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };

  imports = [
    inputs.hyprland.nixosModules.default
  ];

  config = lib.mkIf cfg.enable {

    fonts = {
      packages = with pkgs; [
        # nerdfonts
        (nerdfonts.override {
          fonts = [
            "Iosevka"
          ];
        })
      ];
    };

    programs = {
      hyprland = {
        enable = true;
        xwayland = {
          enable = true;
        };
      };
    };

    environment = {
      systemPackages = with pkgs; [
        hyprpaper
        hyprpicker
        eww-wayland
        rofi-wayland
        wl-clipboard
        configure-gtk
      ];
    };
  };
}

