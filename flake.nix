# in flake.nix
{

  description = "Nitro's Personal Website";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # rust toolchain
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      rust-overlay,
    }:

    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };

        # Needed at runtime
        buildInputs = with pkgs; [ rust-bin.nightly.latest.default ];

        # Needed at compile
        nativeBuildInputs = with pkgs; [
          (rust-bin.nightly.latest.default.override { extensions = [ "rust-analyzer" ]; })
          bacon
          tailwindcss
          hey
          watchexec
          djlint
        ];
      in
      with pkgs;
      {

        # Nix develop Shell program
        devShells.default = mkShell { inherit buildInputs nativeBuildInputs; };

        packages.app.default = {
          buildInputs = [ rust-bin.nightly.latest.default ];
        };
      }
    );
}
