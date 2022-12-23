{ config
, options
, pkgs
, lib
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.vaultwarden;
in
{
  options.modules.shell.vaultwarden = with types; {
    enable = mkBoolOpt false;
    config = mkOpt attrs { };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      bitwarden-cli
    ];

    system.userActivationScripts = mkIf (cfg.config != { }) {
      initVaultwarden = ''
        ${concatStringsSep "\n" (mapAttrsToList (n: v: "bw config ${n} ${v}") cfg.config)}
      '';
    };
  };
}
