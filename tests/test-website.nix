{ inputs, systemMeta, ... }:

{
  name = "test service";

  nodes = {
    server = {
      _module.args = { inherit systemMeta; };

      imports = [
        ./../profiles/common.nix
        ./../profiles/website.nix
        ./../users/users-admin.nix
      ];

      networking.firewall.allowedTCPPorts = [ 80 ];
    };

    client = {
      _module.args = { inherit systemMeta; };

      imports = [
        ./../profiles/common.nix
        ./../users/users-admin.nix
      ];
    };
  };

  testScript = { nodes, ... }:
    ''
      start_all()

      with subtest("Test http service"):
          server.wait_for_unit("lighttpd.service")

          client.succeed("""
              curl --retry 3 --fail http://server:80 | grep "It works"
          """)
    '';
}
