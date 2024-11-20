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
    hashedPassword = "$y$j9T$9gVElYYav0CJTPm9LghtP/$RpYw55FXiUvNYgSkgS8ijhMwX9nWLNJxD38AcSfVZgB";
    openssh.authorizedKeys.keyFiles = [ ./imincik.pub ];
    shell = pkgs.bash;
  };
}
