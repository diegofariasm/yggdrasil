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
          start = "1MiB";
          end = "512MiB";
          bootable = true;
          content = {
            type = "filesystem";
            mountpoint = "/boot";
            format = "vfat";
          };
        }
        {
          name = "nixos-swap";
          start = "512MiB";
          end = "+8GiB";
          part-type = "primary";
          content = {
            type = "swap";
            randomEncryption = true;
          };
        }
        {
          name = "nixos-root";
          start = "8.5GiB";
          end = "+128GiB";
          part-type = "primary";
          content = {
            type = "filesystem";
            mountpoint = "/";
            format = "ext4";
          };
        }
        {
          name = "nixos-home";
          start = "136.5GiB";
          end = "100%";
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
