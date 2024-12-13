{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  # Boot
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  boot.initrd.availableKernelModules = [ "ata_piix" "mptspi" "floppy" "sd_mod" "sr_mod" ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];


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

  swapDevices =
    [{ device = "/dev/disk/by-label/swap"; }];


  # Networking
  networking = {
    useDHCP = lib.mkDefault true;

    firewall = {
      allowedTCPPorts = [
        80 # HTTP (File service)
      ];
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
