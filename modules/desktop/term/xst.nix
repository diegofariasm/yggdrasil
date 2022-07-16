# modules/desktop/term/st.nix
#
# I like (x)st. This appears to be a controversial opinion; don't tell anyone,
# mkay?
{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.term.xst;
in {
  options.modules.desktop.term.xst = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # xst-256color isn't supported over ssh, so revert to a known one
    modules.shell.zsh.rcInit = ''
      [ "$TERM" = xst-256color ] && export TERM=xterm-256color
    '';

    home.packages = with pkgs; [
      xst # st + nice-to-have extensions
      (makeDesktopItem {
        name = "xst";
        desktopName = "Suckless Terminal";
        genericName = "Default terminal";
        icon = "utilities-terminal";
        exec = "${xst}/bin/xst";
        categories = ["Development" "System" "Utility"];
      })
    ];
  };
}
