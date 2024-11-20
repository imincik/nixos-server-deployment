{ config, lib, pkgs, modulesPath, ... }:

# Hardware model: VMware ESXi VM

{
  imports = [ ];

  # Boot
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  boot.initrd.availableKernelModules = [ "ata_piix" "mptspi" "floppy" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ "nfs" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "nfs" ];


  # Filesystems
  fileSystems."/" =
    {
      device = "/dev/disk/by-label/system";
      fsType = "ext4";
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-label/home";
      fsType = "ext4";
    };

  fileSystems."/var/lib/files/scanner" = {
    device = "192.168.171.9:/volume1/scanner";
    fsType = "nfs";
  };

  swapDevices =
    [{ device = "/dev/disk/by-label/swap"; }];


  # Networking
  networking = {

    # Interfaces
    useDHCP = lib.mkDefault true;

    # Firewall
    # allow access to file service
    firewall = {

      # all interfaces
      allowedTCPPorts = [
        80 # HTTP (File service)
      ];
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
