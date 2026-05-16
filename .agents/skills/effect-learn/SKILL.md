---
name: effect-learn
description: >
  Helps the user learn Effect v4 beta — explains concepts, finds examples in the
  submodule, writes idiomatic code, and answers "how do I do X in Effect". Use when
  the user asks about Effect concepts, APIs, patterns, or wants to write Effect code.
---

# Effect v4 Beta Learning Guide

This repo tracks Effect v4 beta via a git submodule at `vendor/effect-smol`.
That submodule is the single source of truth — always read from it, never from
training data or external URLs, since the API is actively evolving.

## Where to look

### 1. Start here: `vendor/effect-smol/LLMS.md`

The submodule ships an `LLMS.md` written specifically for AI assistants. It
describes the current idioms, preferred patterns, and links to the example
files. Read this file first for any learning or code-writing request.

### 2. Working examples: `vendor/effect-smol/ai-docs/src/`

The `ai-docs/` directory contains small, self-contained TypeScript files that
compile and demonstrate focused Effect concepts. `LLMS.md` links to the
relevant files by topic — follow those links rather than guessing paths, since
the file layout may change between beta releases.

### 3. API source: `vendor/effect-smol/packages/effect/src/`

Each module (e.g. `Effect.ts`, `Stream.ts`, `Context.ts`) lives here with full
JSDoc. Read the relevant source file when the user asks about a specific
function or type — this is always up to date with the installed beta version.

### 4. Migration guides: `vendor/effect-smol/MIGRATION.md` and `migration/`

When the user asks about differences from Effect v3, or encounters a renamed or
removed API, read `MIGRATION.md` for the overview and the topic-specific files
in `migration/` for details.

## Workflow

1. Read `vendor/effect-smol/LLMS.md` to understand the current patterns and
   find the relevant example file for the topic.
2. Read the example file(s) it points to from `ai-docs/src/`.
3. If you need exact signatures, read the module source from
   `packages/effect/src/<Module>.ts`.
4. Write or explain code using only what you found in the submodule.
5. To let the user run it: write to `src/main.ts` and use `pnpm dev`.

## What not to do

- Do not rely on training-data knowledge of Effect APIs — they change between
  beta releases.
- Do not fetch external URLs for Effect docs — the submodule is the local,
  pinned, authoritative copy.
- Do not hardcode patterns from a previous conversation — always re-read the
  submodule files so your answer reflects the currently installed version.
