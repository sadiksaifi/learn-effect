# learn-effect

An [Effect](https://effect.website/blog/releases/effect/40-beta/) v4 beta playground. Run an AI coding agent in it (Claude Code, Codex, OpenCode, etc.) and start learning.

## Prerequisites

Install [mise](https://mise.jdx.dev) — it manages [node](https://nodejs.org) and [pnpm](https://pnpm.io) for this repo.

## Setup

```sh
git clone --recurse-submodules https://github.com/sadiksaifi/learn-effect
cd learn-effect
mise install
pnpm install
```

If you cloned without `--recurse-submodules`:

```sh
git submodule update --init
```

## Usage

Edit `src/main.ts` and run:

```sh
pnpm dev        # run with hot reload
pnpm start      # run once
pnpm typecheck
```

## Editor

LSP is preconfigured for VS Code via `.vscode/`. For other editors, see [Effect-TS/tsgo](https://github.com/Effect-TS/tsgo).

## Extensions

| Extension | Purpose |
|---|---|
| [TypeScript Native Preview](https://marketplace.visualstudio.com/items?itemName=TypeScriptTeam.native-preview) | TypeScript language server |
| [OXC](https://marketplace.visualstudio.com/items?itemName=oxc.oxc-vscode) | Linting and formatting |

## Skills

| Skill | Purpose |
|---|---|
| `effect-learn` | Learn Effect concepts using the submodule as reference |
| `effect-smol-updater` | Bump the `effect` beta version and sync the submodule |
