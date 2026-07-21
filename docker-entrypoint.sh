#!/bin/sh
set -e

uv sync --frozen

# Optional: make sure mkdocs is in PATH
export PATH="/app/.venv/bin:$PATH"

exec "$@"