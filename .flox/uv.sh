#!/bin/sh
set -eu

# uv tool install --prerelease=allow sigstore
# uv tool install gallery-dl
# uv tool install meson
# uv tool install sqlfluff
# uv tool install streamrip

uv tool install --with git+https://github.com/averms-forks/beets-extrafiles.git@update_versions beets[fetchart]
uv tool install gersemi
uv tool install pypyp
uv tool install shandy-sqlfmt
