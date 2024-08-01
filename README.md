# Temp



This repository uses git submodules
When building the image via `Nix build`, Nix for some reason ignores this submodule because it wants to track all file in the git repo. this is a good feature when you have untracked files but stupid when you are using git submodules. To fix this, just add `nix build .?submodules=1`

Luckily this will get [removed in 2.20 of Nix](https://github.com/NixOS/nix/pull/7862#issuecomment-1908577578)
