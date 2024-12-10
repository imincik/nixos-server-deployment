let
  # IDENTITIES

  # users and their public ssh keys
  admin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKEzvbBnOC6Q4YZQlpCYWpEmkkw7lV0uL21lwjkNLjRY admin@nixos-deployment.example";

  # list of users able to decrypt secrets
  users = [ admin ];

  # systems and their public ssh host keys
  server1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ6N2T6AxrYwWeoietBn644OAvgVTsvLxCIBnUN+jku0 server@nixos-deployment.example";
  server2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ6N2T6AxrYwWeoietBn644OAvgVTsvLxCIBnUN+jku0 server@nixos-deployment.example";

  # list of systems able to decrypt secrets
  systems = [ server1 server2 ];

in
{
  # SECRETS

  # <SECRET-NAME>.age.publicKeys = <LIST-OF-IDENTITIES>;

  "mySecret1.age".publicKeys = users ++ systems;
  "mySecret2.age".publicKeys = users ++ systems;
}
