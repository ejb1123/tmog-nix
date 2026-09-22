# TMOG for Nix

This flake packages the official Linux AppImage of [Task Manager TMOG](https://tmog.org/).

## Run

```sh
nix run --extra-experimental-features 'nix-command flakes' .
```

## Install

```sh
nix profile install --extra-experimental-features 'nix-command flakes' .
```

TMOG is proprietary software. This flake does not redistribute it; Nix downloads the
official AppImage from tmog.org and verifies its SHA-256 hash.
