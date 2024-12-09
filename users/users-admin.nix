{ config, pkgs, ... }:

# List of server users with super user permissions.

let
  extraGroups = [ "wheel" ];

in
{
  users.users.admin= {
    description = "System superuser";
    isNormalUser = true;
    home = "/home/admin";
    extraGroups = extraGroups;
    password = "";  # WARNING: remove this line for production !
    openssh.authorizedKeys.keyFiles = [ ./admin.pub ];
    shell = pkgs.bash;
  };
}
