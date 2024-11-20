{ config, pkgs, ... }:

{
  services.lighttpd = {
    enable = true;
    document-root = "/var/lib/files";

    extraConfig = ''
      dir-listing.activate = "enable"
    '';
  };

  systemd.services.lighttpd.serviceConfig = {
    User = "root";
    Group = "wheel";
    StateDirectory = "files"; # will create /var/lib/files directory
    StateDirectoryMode = "0775";
  };
}
