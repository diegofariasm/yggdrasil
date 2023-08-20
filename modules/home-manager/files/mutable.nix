{ config, options, lib, pkgs, ... }:

let
  cfg = config.home.mutableFile;

  fileType = baseDir: { name, config, options, ... }: {
    options = {
      url = lib.mkOption {
        type = lib.types.str;
        description = lib.mdDoc ''
          The URL of the file to be fetched.
        '';
        example = "https://github.com/foo-dogsquared/dotfiles.git";
      };

      path = lib.mkOption {
        type = lib.types.str;
        description = lib.mdDoc ''
          The path of the mutable file. By default, it will be relative to the
          home directory.
        '';
        example = lib.literalExpression "\${config.xdg.userDirs.documents}/top-secret";
        default = name;
        apply = p:
          if lib.hasPrefix "/" p then p else "${baseDir}/${p}";
      };

      extractPath = lib.mkOption {
        type = with lib.types; nullOr str;
        description = lib.mdDoc ''
          The path within the archive to be extracted. This is only used if the
          type is `archive`. If the value is `null` then it will extract the
          whole archive into the directory.
        '';
        default = null;
        example = "path/inside/of/the/archive";
      };

      type = lib.mkOption {
        type = lib.types.enum [ "git" "fetch" "archive" "custom" ];
        description = lib.mdDoc ''
          Type that configures the behavior for fetching the URL.

          This accept only certain keywords.

          - For `fetch`, the file will be fetched with `curl`.
          - For `git`, it will be fetched with `git clone`.
          - For `archive`, the file will be fetched with `curl` and extracted
          before putting the file.
          - For `custom`, the file will be passed with a user-given command.
          The `extraArgs` option is now assumed to be a list of a command and
          its arguments.

          The default type is `fetch`.
        '';
        default = "fetch";
        example = "git";
      };

      extraArgs = lib.mkOption {
        type = with lib.types; listOf str;
        description = lib.mdDoc ''
          A list of extra arguments to be included with the fetch command. Take
          note of the commands used for each type as documented from
          `config.home.mutableFile.<name>.type`.
        '';
        default = [ ];
        example = [ "--depth" "1" ];
      };
    };
  };
in
{
  options.home.mutableFile = lib.mkOption {
    type = with lib.types; attrsOf (submodule (fileType config.home.homeDirectory));
    description = lib.mdDoc ''
      An attribute set of mutable files and directories to be declaratively put
      into the home directory. Take note this is not exactly pure (or
      idempotent) as it will only do its fetching when the designated file is
      missing.
    '';
    default = { };
    example = lib.literalExpression ''
      {
        "library/dotfiles" = {
          url = "https://github.com/foo-dogsquared/dotfiles.git";
          type = "git";
        };

        "library/projects/keys" = {
          url = "https://example.com/file.zip";
          type = "archive";
        };
      }
    '';
  };

  config = lib.mkIf (cfg != { }) {
    systemd.user.services.fetch-mutable-files = {
      Unit = {
        Description = "Fetch mutable home-manager-managed files";
        After = [ "default.target" "network-online.target" ];
        Wants = [ "network-online.target" ];
      };

      Service = {
        # We'll assume this service will have lots of things to download so it
        # is best to make the temp directory to only last with the service.
        PrivateUsers = true;
        PrivateTmp = true;

        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart =
          let
            mutableFilesCmds = lib.mapAttrsToList
              (path: value:
                let
                  # NOTE: This is needed for now.
                  # systemd cannot find the user's packages,
                  # so in case you don't get them from the nix store,
                  # it will fail because the service cannot find the command.
                  arc = "${lib.getBin pkgs.archive}/bin/arc";
                  curl = "${lib.getBin pkgs.curl}/bin/curl";
                  git = "${lib.getBin pkgs.git}/bin/git";

                  url = lib.escapeShellArg value.url;
                  path = lib.escapeShellArg value.path;
                  extraArgs = lib.escapeShellArgs value.extraArgs;
                  isFetchType = type: lib.optionalString (value.type == type);
                in
                ''
                  ${isFetchType "git" "[ -d ${path} ] || ${git} clone ${extraArgs} ${url} ${path}"}
                  ${isFetchType "fetch" "[ -e ${path} ] || ${curl} ${extraArgs} ${url} --output ${path}"}
                  ${isFetchType "archive" ''
                    [ -e ${path} ] || {
                      filename=$(${curl} ${extraArgs} --output-dir /tmp --silent --show-error --write-out '%{filename_effective}' --remote-name --remote-header-name --location ${url})
                      ${if (value.extractPath != null) then
                          ''arc extract "/tmp/$filename" ${lib.escapeShellArg value.extractPath} ${path}''
                        else
                          ''arc unarchive "/tmp/$filename" ${path}''
                      }
                    }
                  ''}
                  ${isFetchType "custom" "[ -e ${path} ] || ${extraArgs}"}
                '')
              cfg;

            script = pkgs.writeShellScript "fetch-mutable-files" ''
              ${lib.concatStringsSep "\n" mutableFilesCmds}
            '';
          in
          builtins.toString script;
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
