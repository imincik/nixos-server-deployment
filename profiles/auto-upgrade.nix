{
  # Automatic upgrades
  system.autoUpgrade = {
    enable = true;
    dates = "02:30";
    flake = "github:imincik/nixos-server-deployment/deploy";
    operation = "switch";
    allowReboot = false;
    persistent = false;
    randomizedDelaySec = "10min";
  };

  # Nix garbage collector
  nix.gc = {
    automatic = true;
    persistent = false;
    dates = "03:30";
    options = "--delete-older-than 14d";
  };
}
