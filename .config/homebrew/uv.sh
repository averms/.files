#!/bin/sh
set -eu

export UV_EXCLUDE_NEWER="1 week"

uv tool install \
    --with beets-filetote "beets[fetchart,reflink]"
