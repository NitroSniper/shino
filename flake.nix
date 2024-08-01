#You are trying to move static folder to the docker build. you found a cool article online doing it.
# Basically you have to ovveride the rust toolcahin build to include special stuff
# GOod luck brother

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
    { self, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import inputs.rust-overlay) ];
        pkgs = import inputs.nixpkgs { inherit system overlays; };

        # Binary name of cargo project
        name = "ortin";

        bin = (
          pkgs.rustPlatform.buildRustPackage {
            inherit name;
            cargoLock.lockFile = ./Cargo.lock;
            src = pkgs.lib.cleanSource ./.;
            postInstall = ''
              mkdir app/
              mv static/ $out/
            '';
          }
        );

        docker = pkgs.dockerTools.buildImage {
          inherit name;
          tag = "latest";

          copyToRoot = [ bin ];

          config = {
            Cmd = [ "/bin/${name}" ];
            WorkingDir = "/";
          };
        };
      in
      with pkgs;
      {
        packages = {
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
            # dive 
          ];
        };
        env = {
          # Required by rust-analyzer
          RUST_SRC_PATH = "${pkgs.rustToolchain}/lib/rustlib/src/rust/library";
        };
      }
    );
}
