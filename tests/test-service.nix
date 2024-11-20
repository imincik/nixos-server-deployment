{ inputs, systemMeta, ... }:

{
  name = "test service";

  nodes = {
    server = {
      _module.args = { inherit systemMeta; };

      imports = [
        ./../profiles/common.nix
        ./../profiles/service.nix
      ];

      networking.firewall.allowedTCPPorts = [ 80 ];
    };

    client = {
      _module.args = { inherit systemMeta; };

      imports = [
        ./../profiles/common.nix
      ];
    };
  };

  testScript = { nodes, ... }:
    ''
      start_all()

      with subtest("Test http service"):
          server.wait_for_unit("lighttpd.service")

          server.execute("echo test > /var/lib/files/test.txt")

          client.succeed("""
              curl --fail http://server:80/test.txt | grep test
          """)
    '';
}
