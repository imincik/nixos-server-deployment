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

### Create configuration

1. Create reusable configuration profiles in `profiles` directory

### Create a new host

1. Add new host to `nixosConfiguration` and `apps` outputs in `flake.nix` file

1. Create host declaration in `hosts/<hostname>` directory
  (use `hosts/server1` as example)

1. Test configuration

```bash
nix flake check --no-build
```

1. Test server in VM

```bash
nix run .#<hostname>
```

### Add integration test

1. Add new test to `checks` output in `flake.nix` file

1. Create test script in `tests/<test-name>.nix` file

1. Run test

```bash
nix flake check`
```


## Deployment

1. Initial deployment: TODO - nixos-anywhere


## Maintenance

### System upgrade

1. Merge flake inputs update PR created by `flake-update` workflow

1. Update `deploy` tag using `utils/release.sh` script

1. Wait for system update is performed automatically at 1am
  (see [profiles/auto-upgrade.nix](profiles/auto-upgrade.nix))

### Other

* Get system version (run on server)

```bash
  nixos-version --json
```
