# Example NixOS servers deployment

Install Nix
  [(learn more about this installer)](https://zero-to-nix.com/start/install)
```bash
curl --proto '=https' --tlsv1.2 -sSf \
    -L https://install.determinate.systems/nix \
    | sh -s -- install
  ```

and run `nix develop` to launch development environment.

## MacOS-specific instructions

On macOs, we need to set up a local Linux builder. We'll need this builder to create other NixOS machines, since they require Linux build products.

### Set up Nix Darwin

Nix Darwin is a framework that allows macOS users to manage their system configurations using the Nix package manager. It provides a declarative approach to configuring macOS, similar to how NixOS works for Linux systems. With Nix Darwin, you can define your system settings, installed applications, and services in a single configuration file, making it easy to reproduce and share your setup.

I've initialize a flakes for my Nix Darwin system that includes configurations for linux-builder at https://github.com/Xpirix/nix-darwin-config.git.
You can follow the instructions at https://github.com/Xpirix/nix-darwin-config?tab=readme-ov-file#getting-started to set up your system.

### Build packages using linux-builder

In order to correctly build the packages for the VMs, we need to build them using darwin linux-builder.
```
$ nix run 'nixpkgs#darwin.linux-builder'
```
It should run in the background when building packages.