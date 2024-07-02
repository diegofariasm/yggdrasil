{
  lib,
  config,
  pkgs,
  ...
}:
# Since this will be exported as an installer ISO, you'll have to keep in mind
# about the added imports from nixos-generators. In this case, it simply adds
# the NixOS installation CD profile.
{
  config = lib.mkMerge [
    {
      # Use the systemd-boot EFI boot loader.
      boot.loader.systemd-boot = {
        enable = true;
        netbootxyz.enable = true;
      };

      boot.loader.efi.canTouchEfiVariables = true;
      boot.kernelPackages = pkgs.linuxPackages_6_6;

      # We'll make NetworkManager manage all of them networks.
      networking.wireless.enable = false;

      services = {
        xserver.displayManager = {
          gdm = {
            enable = true;
            autoSuspend = false;
          };
        };
        displayManager = {
          autoLogin = {
            enable = true;
            user = "nixos";
          };
        };
      };
    }

    (
      lib.mkIf (config.formatAttr == "graphicalIsoImage")
      {
        isoImage = {
          isoBaseName = config.networking.hostName;

          squashfsCompression = "zstd -Xcompression-level 12";
        };
      }
    )
  ];
}
