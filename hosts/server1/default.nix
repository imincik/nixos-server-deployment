{ inputs, config, pkgs, lib, hostname, ... }:

{
  networking.hostName = hostname;

  imports = [
    ./hardware.nix

    ../../profiles/common.nix
    ../../profiles/service.nix
    ../../profiles/auto-upgrade.nix

    # system users
    ../../users/users-admin.nix
  ];
}
