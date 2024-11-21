{ config, pkgs, ... }:

# Password hash generation:
# echo "<PASSWORD>" | mkpasswd --stdin --method=yescrypt

let
  extraGroups = [ "wheel" "vboxusers" ];

in
{
  users.users.imincik = {
    description = "Ivan Mincik (admin)";
    isNormalUser = true;
    home = "/home/imincik";
    extraGroups = extraGroups;
    password = "";
    openssh.authorizedKeys.keyFiles = [ ./imincik.pub ];
    shell = pkgs.bash;
  };
}
