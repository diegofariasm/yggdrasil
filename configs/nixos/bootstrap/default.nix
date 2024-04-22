{
  lib,
  config,
  pkgs,
  ...
}: {
  config = lib.mkMerge [
    {
      boot.kernelPackages = pkgs.linuxPackages_6_6;

      # Assume that this will be used for remote installations.
      services.openssh = {
        enable = true;
        allowSFTP = true;
      };
    }

    (lib.mkIf (config.formatAttr == "isoImage") {
      isoImage = {
        isoBaseName = config.networking.hostName;

        squashfsCompression = "zstd -Xcompression-level 11";
      };
    })
  ];
}
