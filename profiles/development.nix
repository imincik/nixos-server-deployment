# Only for development. Don't use in production !

{ config, lib, pkgs, ... }:

let
  hostName = config.networking.hostName;

in
{
  virtualisation.vmVariant = {
    virtualisation.forwardPorts = [ ]
      # HTTP port forwarding for server1
      ++ lib.optional (hostName == "server1" ) { from = "host"; host.port = 8080; guest.port = 80; };
  };
}
