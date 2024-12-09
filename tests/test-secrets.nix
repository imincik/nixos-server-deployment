{ inputs, systemMeta, ... }:

{
  name = "test secrets";

  nodes = {
    server = {
      _module.args = { inherit systemMeta; };

      imports = [
          inputs.agenix.nixosModules.default
        ./install-ssh-keys.nix
        ./../profiles/common.nix
        ./../profiles/secrets.nix
      ];
    };

  };

  testScript = { nodes, ... }:
    ''
      start_all()

      with subtest("Test secret file"):
          server.succeed("""
              grep "my-secret" /etc/my-secret-file1
              grep "my-secret" /etc/my-secret-file2
          """)
    '';
}
