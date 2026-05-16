#!/usr/bin/env bash
set -euo pipefail

repo_root=$(git rev-parse --show-toplevel)
cd "$repo_root"

submodule_path="vendor/effect-smol"
submodule_url="https://github.com/Effect-TS/effect-smol.git"
requested_version="${1:-}"

if [[ -z "$requested_version" ]]; then
  requested_version=$(npm view effect dist-tags.beta)
fi

if [[ -z "$requested_version" ]]; then
  echo "Could not resolve an effect beta version from npm." >&2
  exit 1
fi

tag="effect@${requested_version}"

echo "Updating effect to ${requested_version}"
echo "Matching source tag: ${tag}"

published_repo=$(npm view "effect@${requested_version}" repository.url || true)
if [[ "$published_repo" != *"effect-smol"* ]]; then
  echo "Warning: npm metadata for effect@${requested_version} does not point at effect-smol: ${published_repo}" >&2
fi

if [[ ! -d "$submodule_path" ]]; then
  mkdir -p "$(dirname "$submodule_path")"
  git submodule add "$submodule_url" "$submodule_path"
fi

current_url=$(git -C "$submodule_path" remote get-url origin 2>/dev/null || true)
if [[ "$current_url" != "$submodule_url" ]]; then
  git -C "$submodule_path" remote set-url origin "$submodule_url"
fi

if [[ -f .gitmodules ]]; then
  git config -f .gitmodules "submodule.${submodule_path}.url" "$submodule_url"
  git config -f .gitmodules "submodule.${submodule_path}.path" "$submodule_path"
fi

git submodule sync -- "$submodule_path"

if ! git -C "$submodule_path" ls-remote --exit-code --tags origin "refs/tags/${tag}" >/dev/null 2>&1; then
  echo "No matching tag found in ${submodule_url}: ${tag}" >&2
  exit 1
fi

git -C "$submodule_path" fetch origin "refs/tags/${tag}:refs/tags/${tag}"
git -C "$submodule_path" checkout "$tag"

source_version=$(node -p "require('./${submodule_path}/packages/effect/package.json').version")
if [[ "$source_version" != "$requested_version" ]]; then
  echo "Submodule package version mismatch: expected ${requested_version}, got ${source_version}" >&2
  exit 1
fi

node - "$requested_version" <<'NODE'
const fs = require("node:fs")
const version = process.argv[2]
const path = "package.json"
const pkg = JSON.parse(fs.readFileSync(path, "utf8"))
pkg.dependencies ??= {}
pkg.dependencies.effect = version
fs.writeFileSync(path, `${JSON.stringify(pkg, null, 2)}\n`)
NODE

pnpm install --lockfile-only

git add package.json pnpm-lock.yaml .gitmodules "$submodule_path"

echo
echo "Updated effect dependency and submodule:"
echo "  package.json effect: $(node -p "require('./package.json').dependencies.effect")"
echo "  submodule tag: $(git -C "$submodule_path" describe --tags --match 'effect@*' --exact-match HEAD)"
echo "  submodule commit: $(git -C "$submodule_path" rev-parse HEAD)"
echo
git status --short
