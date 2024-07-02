{
  config,
  lib,
  ...
}: let
  cfg = config.modules.shell.nushell;
in {
  options.modules.shell.nushell = {
    enable = lib.mkOption {
      description = ''
        Whether to enable the nushell shell.
      '';
      type = lib.types.bool;
      default = false;
      example = true;
    };
  };
  config = lib.mkIf cfg.enable {
    programs = {
      nushell = {
        enable = true;

        extraConfig = ''
          source ~/.cache/carapace/init.nu
        '';

        extraEnv = ''
          $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense' # optional
          mkdir ~/.cache/carapace
          carapace _carapace nushell | save --force ~/.cache/carapace/init.nu
        '';
      };

      carapace = {
        enable = true;
        enableNushellIntegration = true;
      };

      thefuck = {
        enable = true;
        enableNushellIntegration = true;
      };
      zoxide = {
        enable = true;
        enableNushellIntegration = true;
      };

      direnv = {
        enable = true;
        enableNushellIntegration = true;
      };

      atuin = {
        enable = true;
        enableNushellIntegration = true;
      };

      eza = {
        enable = true;
        enableNushellIntegration = true;
      };

      starship = {
        enable = true;
        enableNushellIntegration = true;
      };
    };
  };
}
