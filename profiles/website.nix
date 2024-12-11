{ config, pkgs, ... }:

{
  services.lighttpd =
    {
      enable = true;
      document-root = pkgs.my-website;
    };
}
