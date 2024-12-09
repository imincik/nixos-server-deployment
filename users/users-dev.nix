{ config, pkgs, ... }:

# List of server users.

let
  # SSH keys used for remote user support
  remoteSupportSSHKeys = [ ./admin.pub ];
  extraGroups = [ ];

in
{
  users.users.user1 = {
    description = "Test User 1";
    isNormalUser = true;
    home = "/home/user1";
    extraGroups = extraGroups;

    openssh.authorizedKeys.keyFiles = remoteSupportSSHKeys;
  };

  users.users.user2 = {
    description = "Test User 2";
    isNormalUser = true;
    home = "/home/user2";
    extraGroups = extraGroups;

    openssh.authorizedKeys.keyFiles = remoteSupportSSHKeys;
  };
}
