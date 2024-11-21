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
      inputs.darwin.follows = "";
    };
  };

  outputs = inputs@{ self, nixpkgs, agenix }:

    let
      system = "x86_64-linux";
      stateVersion = "24.11";

      srcRevision = if self ? rev then self.rev else "dirty";

      systemMeta = {
        configurationRevision = srcRevision;
        stateVersion = stateVersion;
      };

      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      # Make NixOS server host
      mkHost = hostname: nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/${hostname}
        ];
        specialArgs = { inherit inputs hostname systemMeta; };
      };

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

      apps.${system} = {
        server1 = mkVm "server1";
        server2 = mkVm "server2";
      };


      #
      ### SHELLS
      #

      devShells.${system} = rec {

        # development environment
        dev = pkgs.mkShell {
          buildInputs = [ ];

          shellHook = ''
            function dev-help {
              echo -e "\nWelcome to a NixOS server development environment !"
              echo
              echo "Run server in VM:"
              echo
              echo " 1.  nix run .#<hostname>"
              echo
              echo "Explore server configuration:"
              echo
              echo " 1.  nix repl ./repl.nix --argstr hostname <hostname>"
              echo
              echo "Run tests:"
              echo
              echo " 1.  nix flake check"
              echo
              echo "Launch interactive test environment:"
              echo
              echo " 1.  nix build .\#test-service.driverInteractive"
              echo " 2.  ./result/bin/nixos-test-driver"
              echo " 3.  start_all()"
              echo
              echo "Run 'dev-help' to see this message again."
            }

            dev-help
          '';
        };

        # # Admin shell
        # admin = pkgs.mkShell {
        #   buildInputs = [
        #     # secrets management
        #     agenix.packages.${system}.agenix
        #   ];
        # };

        default = dev;
      };


      #
      ### CHECKS
      #

      test-service = pkgs.nixosTest (import ./tests/test-service.nix { inherit inputs systemMeta; });

      checks.${system} = {
        test-server1 = self.test-service;
      };
    };
}
