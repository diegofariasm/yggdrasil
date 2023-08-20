{ disks ? [ "/dev/nvme0n1" ], ... }:

{
  disk.sda = {
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
          end = "9GiB";
          part-type = "primary";
          content = {
            type = "swap";
            randomEncryption = true;
          };
        }
        {
          name = "nixos-root";
          start = "9GiB";
          end = "137GiB";
          part-type = "primary";
          content = {
            type = "filesystem";
            mountpoint = "/";
            format = "ext4";
          };
        }
        {
          name = "nixos-home";
          start = "137GiB";
          end = "201GiB";
          part-type = "primary";
          content = {
            type = "filesystem";
            mountpoint = "/home";
            format = "ext4";
          };
        }

      ];
    };
  };
}
