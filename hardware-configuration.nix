# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "firewire_ohci" "usb_storage" "sd_mod" "sr_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/06886c74-6f0e-4d0d-bf34-d3cae629be57";
      fsType = "btrfs";
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/1190c6de-6fd2-4a18-9678-a443c495a9bd";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/23a6e822-43fd-4a7d-94c8-19da3d040014";
      fsType = "ext4";
    };

  swapDevices = [ ];

  nix.maxJobs = lib.mkDefault 4;
}
