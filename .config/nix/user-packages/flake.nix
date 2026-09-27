{
  description = "Declarative user-level packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {nixpkgs, ...}: let
    allSystems = ["aarch64-darwin" "aarch64-linux" "x86_64-linux"];
    forAllSystems = f:
      nixpkgs.lib.genAttrs allSystems (system: f nixpkgs.legacyPackages.${system});
  in {
    packages = forAllSystems (
      pkgs: {
        default = pkgs.buildEnv {
          name = "user-packages";

          paths = with pkgs; [
            babashka
            czkawka
            fd
            hyperfine
          ];

        };

        occasional = pkgs.buildEnv {
          name = "occasional-packages";

          paths = with pkgs; [
            cosign
            difftastic
            editorconfig-checker
            fdk-aac-encoder
            gallery-dl
            goat
            graphviz
            hurl
            jdupes
            llvm
            mat2
            mergiraf
            mozjpeg
            parquet-tools
            qpdf
            qrencode
            quarto
            rsgain
            scryer-prolog
            sqlfluff
            streamrip
            yt-dlp
          ];

        };
      }
    );
  };
}
