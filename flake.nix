{
  description = "Example NixOS deployment";

  # nixConfig = {
  #   extra-substituters = [ "https://example.cachix.org" ];
  #   extra-trusted-public-keys = [ "example.cachix.org-1:xxxx=" ];
  # };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    agenix = {
      url = "github:ryantm/agenix/0.13.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, agenix }:

    let
      # Flake system
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; config.allowUnfree = true; });

      # Version
      stateVersion = "24.11";
      srcRevision = if self ? rev then self.rev else "dirty";
      systemMeta = {
        configurationRevision = srcRevision;
        stateVersion = stateVersion;
      };

      # Make NixOS server host
      mkHost = hostname: nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/${hostname}
        ];
        specialArgs = { inherit inputs hostname systemMeta; };
      };

      # Make NixOS VM
      mkVm = hostname: {
        type = "app";
        program = "${self.nixosConfigurations.${hostname}.config.system.build.vm}/bin/run-${hostname}-vm";
      };

    in
    {

      #
      ### HOSTS
      #

      nixosConfigurations = {
        server1 = mkHost "server1";
        server2 = mkHost "server2";
      };

      apps = forAllSystems (system: {
        server1 = mkVm "server1";
        server2 = mkVm "server2";
      });


      #
      ### SHELLS
      #

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in

        {
          # development environment
          default = pkgs.mkShell {

            buildInputs = [ ];

            shellHook = ''
              function dev-help {
                echo -e "\nWelcome to a NixOS server development environment !"
                echo
                echo "Show this flake content:"
                echo
                echo "     nix flake show"
                echo
                echo "Run server in VM:"
                echo
                echo "     nix run .#<hostname>"
                echo
                echo "Run tests:"
                echo
                echo "     nix flake check"
                echo
                echo "Launch interactive test environment:"
                echo
                echo "     nix run .#checks.<system>.<test>.driverInteractive -- interactive"
                echo "     start_all()"
                echo
                echo "Explore server configuration:"
                echo
                echo "     nix repl ./repl.nix --argstr hostname <hostname>"
                echo
                echo "Run 'dev-help' to see this message again."
              }

              dev-help
            '';
          };
        });


      #
      ### CHECKS
      #

      checks = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in

        {
          test-server1 = pkgs.testers.runNixOSTest (import ./tests/test-service.nix { inherit inputs systemMeta; });
        });
    };
}
