# Example NixOS servers deployment

## Quick start

Install Nix
  [(learn more about this installer)](https://zero-to-nix.com/start/install)
```bash
curl --proto '=https' --tlsv1.2 -sSf \
    -L https://install.determinate.systems/nix \
    | sh -s -- install
  ```

and run `nix develop` to launch development environment.


## Development workflow

### Create a new host

1. Add new host to `nixosConfiguration` and `apps` outputs in `flake.nix` file

1. Create host declaration to `hosts/<hostname>` directory

1. Test configuration using `nix flake check --no-build`

### Add integration test

1. Add new test to `checks` output in `flake.nix` file

1. Create test script in `tests/<test-name>.nix` file

1. Run test using `nix flake check`


## Deployment

TODO - nixos-anywhere


## Maintenance

* 

* Get server configuration version

```bash
  nixos-version --json
```
