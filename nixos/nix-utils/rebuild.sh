#!/usr/bin/env bash
set -e

# better cd command
pushd ~/nixos/

# edit the config
hx configuration.nix

# this is just code formatting
alejandra .&>/dev/null

# show the git diff
git diff -U0 *.nix

# alert the user
echo "NixOS Rebuilding...."

# rebuild the system
sudo nixos-rebuild switch --impure --flake ~/nixos &>nixos-switch.log || (cat nixos-switch.log | grep --color error && false)
gen=$(nixos-rebuild list-generations | grep current)

git commit -am "$gen"

popd
