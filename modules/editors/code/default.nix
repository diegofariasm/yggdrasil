{ config
, options
, lib
, pkgs
, ...
}:
with lib;
with lib.my; let
  cfg = config.modules.editors.code;
  vscodePname = config.home.programs.vscode.package.pname;
  configDir = {
    "vscode" = "Code";
    "vscode-insiders" = "Code - Insiders";
    "vscodium" = "VSCodium";
  }.${vscodePname};

  sysDir =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "${config.home.homeDirectory}/Library/Application Support"
    else
      "$XDG_CONFIG_HOME";

  userFilePath = "${sysDir}/${configDir}/User/settings.json";
in
{
  options.modules.editors.code = {
    enable = mkBoolOpt false;
    mutable = mkBoolOpt true;
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.user.name} = { lib, ... }: {

      home.activation = mkIf cfg.mutable {
        removeExistingVSCodeSettings = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
          rm -rf "${userFilePath}"
        '';

        overwriteVSCodeSymlink =
          let
            userSettings = config.home.programs.vscode.userSettings;
            jsonSettings = pkgs.writeText "tmp_vscode_settings" (builtins.toJSON userSettings);
          in
          lib.hm.dag.entryAfter [ "linkGeneration" ] ''
            rm -rf "${userFilePath}"
            cat ${jsonSettings} | ${pkgs.jq}/bin/jq --monochrome-output > "${userFilePath}"
          '';
      };
    };

    home.programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      userSettings = import ./settings.nix;
      extensions = import ./extensions.nix { inherit pkgs; };

    };

    fonts.fonts = with pkgs; [
      jetbrains-mono
    ];
    home.packages = with pkgs; [
      nixpkgs-fmt
    ];
  };
}

