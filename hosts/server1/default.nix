{ inputs, outputs, config, pkgs, lib, hostname, ... }:

{
  networking.hostName = hostname;

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ outputs.overlays.default ];
  };

  imports = [
    ./hardware.nix

    ../../profiles/common.nix
    ../../profiles/website.nix
    ../../profiles/auto-upgrade.nix

    # system users
    ../../users/users-admin.nix
    ../../users/users-dev.nix

    # development (do not include for production !)
    ../../profiles/development.nix
  ];
}
