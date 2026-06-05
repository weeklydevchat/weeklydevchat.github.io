#!/bin/sh
set -e

uv sync --frozen --no-dev   # or remove --no-dev if you want dev deps

# Optional: make sure mkdocs is in PATH
export PATH="/app/.venv/bin:$PATH"

exec "$@"