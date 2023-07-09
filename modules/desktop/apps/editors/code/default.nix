{ config
, options
, inputs
, lib
, pkgs
, ...
}:
with builtins;
with lib;
with lib.my; let
  inherit (inputs) vscode-server;
  cfg = config.modules.desktop.apps.editors.code;
  vscodePname = config.home-manager.users.${config.user.name}.programs.vscode.package.pname;
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
  options.modules.desktop.apps.editors.code = {
    enable = mkBoolOpt false;
    mutable = mkBoolOpt true;
  };
  # NOTE: imports need to be done outside the cfg.enable scope
  imports = [ vscode-server.nixosModule ];
  config = mkIf cfg.enable {
    services.vscode-server = {
      enable = true;
      installPath = "~/.vscode-server";
    };
    home-manager.users.${config.user.name} = { lib, ... }: {
      home.activation = mkIf cfg.mutable {
        removeExistingVSCodeSettings = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
          rm -rf "${userFilePath}"
        '';

        overwriteVSCodeSymlink =
          let
            userSettings = config.home-manager.users.${config.user.name}.programs.vscode.userSettings;
            jsonSettings = pkgs.writeText "tmp_vscode_settings" (builtins.toJSON userSettings);
          in
          lib.hm.dag.entryAfter [ "linkGeneration" ] ''
            rm -rf "${userFilePath}"
            cat ${jsonSettings} | ${pkgs.jq}/bin/jq --monochrome-output > "${userFilePath}"
          '';
      };
    };

    maiden.programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      userSettings = import ./settings.nix;
      extensions = import ./extensions.nix { inherit pkgs; };
    };

    fonts.fonts = with pkgs; [
      jetbrains-mono
    ];
    user.packages = with pkgs; [
      nixpkgs-fmt
    ];
  };
}

