{
  disko.devices = {
    disk = {
      root = {
        type = "disk";
        # Ideally would use e.g. `/dev/oracleoci/oraclevda` and `...vdb` per
        # https://docs.oracle.com/en-us/iaas/Content/Block/References/consistentdevicepaths.htm
        # but NixOS doesn't support the guest extensions(?) needed to handle those paths.
        # Instead just use a single disk, which ought to always be called `sda`.
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "5G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };

    zpool = {
      zroot = {
        type = "zpool";
        options.autoexpand = "on";
        rootFsOptions = {
          compression = "zstd";
        };
        datasets = {
          "root" = {
            type = "zfs_fs";
            mountpoint = "/";
          };
          "nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
          };
          "pool" = {
            type = "zfs_fs";
            mountpoint = "/pool";
          };
        };
      };
    };
  };
}
