---
name: effect-smol-updater
description: Updates this repo to a requested or latest beta version of the npm package effect, syncing package.json, pnpm-lock.yaml, and the vendor/effect-smol git submodule to the matching effect@<version> tag from Effect-TS/effect-smol. Use when the user asks to bump, upgrade, or sync Effect/effect-smol beta versions in this repository.
---

# Effect Smol Updater

This project tracks the npm package `effect` while keeping the matching source checkout as a git submodule at `vendor/effect-smol`.

Important mapping:

- npm package: `effect`
- source repo: `https://github.com/Effect-TS/effect-smol.git`
- submodule path: `vendor/effect-smol`
- release tag format: `effect@<version>`

## Workflow

When asked to update Effect/effect-smol:

1. Resolve the target version:
   - If the user gives a version, use it exactly, e.g. `4.0.0-beta.67`.
   - If no version is given, use the npm beta dist-tag: `npm view effect dist-tags.beta`.
2. Run the helper script from the repo root:

   ```bash
   .agents/skills/effect-smol-updater/scripts/update-effect-smol.sh [version]
   ```

3. Verify:

   ```bash
   node -p "require('./package.json').dependencies.effect"
   node -p "require('./vendor/effect-smol/packages/effect/package.json').version"
   git -C vendor/effect-smol describe --tags --match 'effect@*' --exact-match HEAD
   git submodule status vendor/effect-smol
   ```

4. Run project checks if dependencies changed:

   ```bash
   pnpm typecheck
   pnpm build
   ```

5. Show the user the changed files and exact pinned submodule commit. Commit only if the user asks.

## Notes

- Do not point this submodule at `effect-ts/effect` for Effect v4 beta packages. The npm metadata for `effect@4.0.0-beta.*` points to `Effect-TS/effect-smol`.
- Keep `vendor/effect-smol` in detached HEAD at the exact `effect@<version>` tag so the parent repo records a reproducible submodule commit.
- If the requested npm version has no matching `effect@<version>` tag in `Effect-TS/effect-smol`, stop and report the mismatch instead of guessing a commit.
