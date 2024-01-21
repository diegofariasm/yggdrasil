{ pkgs, config, inputs, lib, ... }:
let
  cfg = config.modules.desktop;

  # A util for setting the gtk theme.
  # This ins needed only in wayland, but it helps
  # with other environments as well, or atleast i think.
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

  config =
    let
      enabledDesktops = lib.my.countAttrs (_: module: lib.isAttrs module && builtins.hasAttr "enable" module && module.enable) cfg;
    in
    lib.mkIf (enabledDesktops > 0) {
      assertions =
        [{
          assertion = enabledDesktops <= 1;
          message = ''
            Only one desktop setup should be enabled at any given time.
          '';
        }];

      fonts.packages = with pkgs; [
        (nerdfonts.override {
          fonts = [
            "Iosevka"
          ];
        })
	fonts.icomoon
      ];


      environment.systemPackages = with pkgs; [
        jq
        socat
        libnotify
        xsettingsd
        wl-clipboard
        configure-gtk
      ];

    };

}
