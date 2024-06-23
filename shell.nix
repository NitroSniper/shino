{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  buildInputs = with pkgs; [
    tailwindcss
    hey
    watchexec
    djlint
  ];
}
