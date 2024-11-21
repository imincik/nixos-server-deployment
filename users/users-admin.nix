{ config, pkgs, ... }:

# List of server users with super user permissions.

let
  extraGroups = [ "wheel" ];

in
{
  users.users.imincik = {
    description = "Ivan Mincik (admin)";
    isNormalUser = true;
    home = "/home/imincik";
    extraGroups = extraGroups;
    password = "";  # WARNING: remove this line for production !
    openssh.authorizedKeys.keyFiles = [ ./imincik.pub ];
    shell = pkgs.bash;
  };
}
