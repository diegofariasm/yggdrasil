{ disks, ... }:

{
  disk.disk0 = {
    device = builtins.elemAt disks 0;
    type = "disk";
    content = {
      format = "gpt";
      type = "table";
      partitions = [
        {
          name = "nixos-boot";
          start = "0";
          end = "1GiB";
          bootable = true;
          content = {
            type = "filesystem";
            mountpoint = "/boot";
            format = "vfat";
          };
        }
        {
          name = "nixos-swap";
          start = "1GiB";
          end = "5GiB";
          content = {
            type = "swap";
            randomEncryption = true;
          };
        }
        {
          name = "nixos";
          start = "5GiB";
          content = {
            type = "filesystem";
            mountpoint = "/";
            format = "ext4";
          };
        }
      ];
    };
  };
}
