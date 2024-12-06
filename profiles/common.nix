{ config, pkgs, systemMeta, ... }:

{
  # Security
  security.sudo = {
    enable = true;
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };

  # SSH
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # Nix
  nix.settings.trusted-users = [ "@wheel" ];

  # Nix Flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  # Other
  documentation.nixos.enable = false;

  # System
  system.configurationRevision = systemMeta.configurationRevision;
  system.stateVersion = systemMeta.stateVersion;
}
