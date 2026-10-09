{
  description = "Declarative user-level packages.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {nixpkgs, ...}: let
    overlay = final: prev: {
      jdk = final.temurin-bin-27;

      # pyp 1.3.0's tests fail on Python 3.14
      pyp = prev.pyp.overridePythonAttrs (old: {
        patches =
          (old.patches or [])
          ++ [
            (final.fetchpatch2 {
              name = "pyp-python-3.14-tests.patch";
              url = "https://github.com/hauntsaninja/pyp/commit/536464aad4752aac3d43d253139c7761bda076d3.patch?full_index=1";
              hash = "sha256-h4pCd9SJX0K5M3lNwGaqb1x4ki1A+8ocA3Kk5zDEO2M=";
            })
          ];
      });
    };

    pkgsFor = system:
      import nixpkgs {
        inherit system;
        config.allowUnfreePackages = ["claude-code"];
        overlays = [overlay];
      };

    systems = ["aarch64-darwin" "aarch64-linux" "x86_64-linux"];

    forEachSystemPkgs = f:
      nixpkgs.lib.genAttrs systems (system: f (pkgsFor system));
  in {
    formatter = forEachSystemPkgs (pkgs: pkgs.alejandra);

    packages = forEachSystemPkgs (pkgs: let
      # standalone docker-compose does not find buildx,
      # set DOCKER_CLI_PLUGIN_DIRS so it does
      docker-compose-with-buildx = pkgs.symlinkJoin {
        inherit (pkgs.docker-compose) pname version meta;
        paths = [pkgs.docker-compose];
        nativeBuildInputs = [pkgs.makeBinaryWrapper];
        postBuild = ''
          wrapProgram $out/bin/docker-compose \
            --prefix DOCKER_CLI_PLUGIN_DIRS : ${pkgs.docker-buildx}/libexec/docker/cli-plugins
        '';
      };
    in
      {
        default = pkgs.buildEnv {
          name = "user-packages";
          paths = with pkgs;
            [
              age
              agent-browser
              awscli2
              b3sum
              babashka
              bash-language-server
              bottom
              claude-code
              delta
              docker-buildx
              docker-compose-with-buildx
              dua
              duckdb
              fd
              fish
              fzf
              gh
              git
              harper
              hyperfine
              jj-vine
              jujutsu
              lazygit
              libarchive
              markdown-oxide
              neovim
              netcat # this is the nice openbsd version
              nono
              numbat
              ocamlPackages.cpdf
              pi-coding-agent
              pyp
              rclone
              remarshal
              restic
              ripgrep
              ruff
              samurai
              scc
              tree
              ty
              typst
              uv
              watchexec
            ]
            ++ lib.optionals stdenv.hostPlatform.isLinux [
              mold-unwrapped
            ]
            ++ lib.optionals stdenv.hostPlatform.isDarwin [
              bash
              podman
              poppler-utils
            ];
        };

        occasional = pkgs.buildEnv {
          name = "occasional-packages";
          paths = with pkgs;
            [
              cargo-auditable
              cargo-llvm-cov
              cargo-nextest
              cosign
              crane
              czkawka
              delve
              difftastic
              dnscontrol
              editorconfig-checker
              fdk-aac-encoder
              gallery-dl
              git-pages-cli
              goat
              golangci-lint
              gopls
              graphviz
              hurl
              jdupes
              ldns
              llvm
              mat2
              mediainfo
              mergiraf
              mozjpeg
              nvtopPackages.full
              opentofu
              opus-tools
              osv-scanner
              oxipng
              parquet-tools
              pinact
              pnpm
              pwgen
              qpdf
              qrencode
              quarto
              rsgain
              rumdl
              rustup
              samply
              scryer-prolog
              shellcheck
              shfmt
              sqlfluff
              streamrip
              stylua
              typstyle
              xlsclients
              yt-dlp
              zizmor
            ]
            ++ lib.optionals stdenv.hostPlatform.isLinux [
              valgrind
            ];
        };
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        # Target of the /run/opengl-driver symlink
        graphics = pkgs.buildEnv {
          name = "graphics";
          paths = with pkgs; [
            mesa
          ];
        };
      });
  };
}
