{
  description = "Example NixOS deployment";

  # nixConfig = {
  #   extra-substituters = [ "https://example.cachix.org" ];
  #   extra-trusted-public-keys = [ "example.cachix.org-1:xxxx=" ];
  # };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    agenix = {
      url = "github:ryantm/agenix/0.15.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, agenix }:
    let
      inherit (self) outputs;

      # Flake system
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ self.overlays.default ];
      });

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
          agenix.nixosModules.default
        ];
        specialArgs = {
          inherit inputs outputs hostname systemMeta;
        };
      };

      # Make NixOS VM
      mkVm = hostname: {
        type = "app";
        program = "${self.nixosConfigurations.${hostname}.config.system.build.vm}/bin/run-${hostname}-vm";
      };

    in
    {
      #
      ### PACKAGES
      #

      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          inherit (pkgs) my-website;
        });

      overlays.default =
        final: prev:
        {
          my-website = final.callPackage ./pkgs/website { };
        };


      #
      ### HOSTS
      #

      nixosConfigurations = {
        # <hostname> = mkHost "<hostname>";

        server1 = mkHost "server1";
        server2 = mkHost "server2";
      };

      apps = forAllSystems (system: {
        # <hostname> = mkVm "<hostname>";

        server1 = mkVm "server1";
        server2 = mkVm "server2";
      });


      #
      ### CHECKS
      #

      checks = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in

        {
          # <test-name> = pkgs.testers.runNixOSTest (import ./tests/<test-script>.nix { inherit inputs outputs systemMeta; });

          test-website = pkgs.nixosTest (import ./tests/test-website.nix { inherit inputs outputs systemMeta; });
          test-secrets = pkgs.nixosTest (import ./tests/test-secrets.nix { inherit inputs outputs systemMeta; });
        });


      #
      ### SHELLS
      #

      devShells = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in

        {
          # Development environment
          default = pkgs.mkShell {

            buildInputs = [
              inputs.agenix.packages.${system}.agenix # secrets management
            ];

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
                echo "     nix run .#checks.<system>.<test>.driverInteractive -- --interactive"
                echo "     start_all()"
                echo
                echo "Run 'dev-help' to see this message again."
              }

              dev-help
            '';
          };
        });
    };
}
