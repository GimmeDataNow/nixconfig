#! /usr/bin/env bash

# this function converts from an url to a hash
nix-prefetch-url "$1" | xargs nix hash to-sri --type sha256

# this function was found here:
# https://discourse.nixos.org/t/why-does-nix-prefetch-url-not-return-hashes-in-sri-format/18271/4
