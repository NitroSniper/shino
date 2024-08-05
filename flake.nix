{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

  };

  outputs =
    { ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {

          packages = with pkgs; [
            nodejs
            node2nix
            yarn
            nodePackages."@astrojs/language-server"
            nodePackages.typescript
            nodePackages.typescript-language-server
            nodePackages.prettier_d_slim
          ];
        };
      }
    );
}
