{
  description = "Declarative user-level packages.";

  inputs = {
    nixpkgs.url = "flake:nixpkgs/nixpkgs-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      overlay = final: prev: {
        # pyp 1.3.0's tests fail on Python 3.14
        pyp = prev.pyp.overridePythonAttrs (old: {
          patches = (old.patches or [ ]) ++ [
            (final.fetchpatch2 {
              hash = "sha256-h4pCd9SJX0K5M3lNwGaqb1x4ki1A+8ocA3Kk5zDEO2M=";
              name = "pyp-python-3.14-tests.patch";
              url = "https://github.com/hauntsaninja/pyp/commit/536464aad4752aac3d43d253139c7761bda076d3.patch?full_index=1";
            })
          ];
        });
      };

      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfreePackages = [ "claude-code" ];
          overlays = [ overlay ];
        };

      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];

      forEachSystemPkgs = f: nixpkgs.lib.genAttrs systems (system: f (pkgsFor system));
    in
    {
      formatter = forEachSystemPkgs (pkgs: pkgs.nixfmt);

      packages = forEachSystemPkgs (
        pkgs:
        let
          cpdf-bin = pkgs.runCommand "cpdf-bin-${pkgs.ocamlPackages.cpdf.version}" {
            inherit (pkgs.ocamlPackages.cpdf) version meta;
            disallowedReferences = [ pkgs.ocaml ];
          } "install -Dm755 ${pkgs.ocamlPackages.cpdf}/bin/cpdf $out/bin/cpdf";

          # standalone docker-compose does not find buildx,
          # set DOCKER_CLI_PLUGIN_DIRS so it does
          docker-compose-with-buildx = pkgs.symlinkJoin {
            inherit (pkgs.docker-compose) pname version meta;
            nativeBuildInputs = [ pkgs.makeBinaryWrapper ];
            paths = [ pkgs.docker-compose ];
            postBuild = ''
              wrapProgram $out/bin/docker-compose \
                --prefix DOCKER_CLI_PLUGIN_DIRS : ${pkgs.docker-buildx}/libexec/docker/cli-plugins
            '';
          };
        in
        {
          default = pkgs.buildEnv {
            name = "user-packages";
            paths = [
              cpdf-bin
              docker-compose-with-buildx
              pkgs.age
              pkgs.agent-browser
              pkgs.b3sum
              pkgs.babashka-unwrapped
              pkgs.bash-language-server
              pkgs.bottom
              pkgs.claude-code
              pkgs.delta
              pkgs.direnv
              pkgs.docker-buildx
              pkgs.dua
              pkgs.duckdb
              pkgs.fd
              pkgs.fish
              pkgs.fzf
              pkgs.gh
              pkgs.git
              pkgs.harper
              pkgs.hyperfine
              pkgs.jj-vine
              pkgs.jujutsu
              pkgs.lazygit
              pkgs.libarchive
              pkgs.markdown-oxide
              pkgs.neovim
              pkgs.netcat # this is the nice openbsd version
              pkgs.nono
              pkgs.numbat
              pkgs.pi-coding-agent
              pkgs.pyp
              pkgs.rclone
              pkgs.remarshal
              pkgs.restic
              pkgs.ripgrep
              pkgs.ruff
              pkgs.samurai
              pkgs.scc
              pkgs.tree
              pkgs.ty
              pkgs.typst
              pkgs.uv
              pkgs.watchexec
            ]
            ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
              pkgs.bash
              pkgs.podman
              pkgs.poppler-utils
              pkgs.python314
            ];
          };

          occasional = pkgs.buildEnv {
            name = "occasional-packages";
            paths = [
              pkgs.awscli2
              pkgs.cargo-auditable
              pkgs.cargo-llvm-cov
              pkgs.cargo-nextest
              pkgs.cosign
              pkgs.crane
              pkgs.czkawka
              pkgs.delve
              pkgs.difftastic
              pkgs.dnscontrol
              pkgs.editorconfig-checker
              pkgs.fdk-aac-encoder
              pkgs.gallery-dl
              pkgs.git-pages-cli
              pkgs.goat
              pkgs.golangci-lint
              pkgs.gopls
              pkgs.graphviz
              pkgs.hurl
              pkgs.jdupes
              pkgs.ldns
              pkgs.llvm
              pkgs.mat2
              pkgs.mediainfo
              pkgs.mergiraf
              pkgs.mozjpeg
              pkgs.nvtopPackages.full
              pkgs.opentofu
              pkgs.opus-tools
              pkgs.osv-scanner
              pkgs.oxipng
              pkgs.parquet-tools
              pkgs.pinact
              pkgs.pnpm
              pkgs.pwgen
              pkgs.qpdf
              pkgs.qrencode
              pkgs.quarto
              pkgs.rsgain
              pkgs.rumdl
              pkgs.rustup
              pkgs.samply
              pkgs.scryer-prolog
              pkgs.shellcheck
              pkgs.shfmt
              pkgs.sqlfluff
              pkgs.streamrip
              pkgs.stylua
              pkgs.typstyle
              pkgs.xlsclients
              pkgs.yt-dlp
              pkgs.zizmor
            ]
            ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
              pkgs.valgrind
            ];
          };
        }
        // pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
          # Target of the /run/opengl-driver symlink
          graphics = pkgs.buildEnv {
            name = "graphics";
            paths = [
              pkgs.mesa
              # OpenCL, radeonsi devices need RUSTICL_ENABLE=radeonsi set
              # pkgs.mesa.opencl
            ];
          };
        }
      );
    };
}
