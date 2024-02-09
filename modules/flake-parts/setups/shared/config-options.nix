{
  lib,
  systems,
  ...
}: {
  options = {
    systems = lib.mkOption {
      type = with lib.types; listOf str;
      default = systems;
      defaultText = "config.systems";
      example = ["x86_64-linux"];
      description = ''
        A list of platforms that the NixOS configuration is supposed to be
        deployed on.
      '';
    };

    modules = lib.mkOption {
      type = with lib.types; listOf raw;
      default = [];
      description = ''
        A list of NixOS modules specific for that host.
      '';
    };

    persist = {
      directories = lib.smkOption {
        type = with lib.types;
          listOf (either str (submodule {
            options = {
              directory = mkOption {
                type = str;
                default = null;
                description = "The directory path to be linked.";
              };
              method = mkOption {
                type = types.enum ["bindfs" "symlink"];
                default = "bindfs";
                description = ''
                  The linking method that should be used for this
                  directory. bindfs is the default and works for most use
                  cases, however some programs may behave better with
                  symlinks.
                '';
              };
            };
          }));
        default = [];
      };

      files = lib.mkOption {
        type = with lib.types; listOf str;
        default = [];
      };
    };
  };
}
