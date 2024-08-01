# Temp


This repository uses git submodules for certain assets like my blogs. When building the image via `nix build`, Nix, for some reason, ignores this submodule because it wants to track all file in the git repo. This is a good feature when you have untracked files but stupid when you are using git submodules.

To fix this, just add `nix build .?submodules=1` and when targeting a package `nix build .?submodules=1#docker`

Luckily this will get [removed in 2.20 of Nix](https://github.com/NixOS/nix/pull/7862#issuecomment-1908577578)
