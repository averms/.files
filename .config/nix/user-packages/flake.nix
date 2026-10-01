{
  description = "Declarative user-level packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {nixpkgs, ...}: let
    allSystems = ["aarch64-darwin" "aarch64-linux" "x86_64-linux"];
    pkgsFor = system:
      import nixpkgs {
        inherit system;
        overlays = [
          (final: _prev: {
            jdk = final.temurin-bin-27;
          })
        ];
      };
    forAllSystems = f:
      nixpkgs.lib.genAttrs allSystems (system: f (pkgsFor system));
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
            netcat # this is the nice openbsd version
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
