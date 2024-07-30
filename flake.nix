{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # rust dev toolchain
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import inputs.rust-overlay) ];
        pkgs = import inputs.nixpkgs { inherit system overlays; };

        bin = pkgs.rustPlatform.buildRustPackage {
          name = "ortin";
          cargoLock.lockFile = ./Cargo.lock;
          src = pkgs.lib.cleanSource ./.;
        };

        docker = pkgs.dockerTools.buildImage {
          name = "ortin";
          tag = "latest";
          copyToRoot = [ bin ];
          config = {
            Cmd = [ "${bin}/bin/ortin" ];
          };
        };
      in
      # Needed at compile
      with pkgs;
      {
        packages = {
          # new package: 👇
          inherit bin docker;
          default = bin;
        };
        devShells.default = mkShell {
          buildInputs = [
            (rust-bin.stable.latest.default.override {
              extensions = [
                "rust-src"
                "rustfmt"
                "rust-analyzer"
              ];
            })
            bacon
            tailwindcss
            hey
            watchexec
            djlint
          ];
        };
        env = {
          # Required by rust-analyzer
          RUST_SRC_PATH = "${pkgs.rustToolchain}/lib/rustlib/src/rust/library";
        };
      }
    );
}
