#!/usr/bin/env bash

set -euo pipefail

if ! command -v node >/dev/null 2>&1; then
  echo "Error: Node.js is required but was not found in PATH." >&2
  exit 1
fi

if ! command -v pnpm >/dev/null 2>&1; then
  echo "Error: pnpm is required but was not found in PATH." >&2
  exit 1
fi

if [[ ! -f package.json ]]; then
  echo "Error: no package.json found. Run this script from a generated project root." >&2
  exit 1
fi

if [[ ! -f index.html ]]; then
  echo "Error: no index.html found in the project root." >&2
  exit 1
fi

printf '%s\n' 'Building a single HTML artifact with Vite and Rolldown...'
rm -rf dist bundle.html
pnpm exec vite build

if [[ ! -f dist/index.html ]]; then
  echo "Error: Vite did not produce dist/index.html." >&2
  exit 1
fi

cp dist/index.html bundle.html
rm -rf dist

FILE_SIZE="$(du -h bundle.html | cut -f1)"
FILE_URL="$(node -e 'const { pathToFileURL } = require("node:url"); console.log(pathToFileURL(process.cwd() + "/bundle.html").href)')"
printf 'Bundle complete: bundle.html (%s)\n' "$FILE_SIZE"
printf 'Open in browser: %s\n' "$FILE_URL"
printf '%s\n' 'The generated file can also be shared as an artifact.'
