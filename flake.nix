{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # rust dev toolchain
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        name = "shino";

        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [ (import inputs.rust-overlay) ];
        };

        # this is how we can tell crane to use our toolchain!
        craneLib = (inputs.crane.mkLib pkgs).overrideToolchain (
          p: p.rust-bin.nightly.latest.default.override { }
        );

        bin = craneLib.buildPackage {
          src = pkgs.lib.cleanSource ./.;
          strictDeps = false;
          postInstall = ''
            mv resources/ $out/
          '';
        };

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
      {
        packages = {
          inherit bin docker;
          default = bin;
        };
        devShells.default = craneLib.devShell {

          inputsFrom = [ bin ];

          packages = with pkgs; [
            rust-analyzer
            bacon
            tailwindcss
            hey
            watchexec
            djlint
            # dive 
          ];
        };

      }
    );
}
