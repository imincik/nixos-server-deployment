{ inputs, config, pkgs, lib, hostname, ... }:

{
  networking.hostName = hostname;

  imports = [
    ./hardware.nix

    ../../profiles/common.nix
    ../../profiles/auto-upgrade.nix

    # system users
    ../../users/users-admin.nix
    ../../users/users-dev.nix
  ];
}
