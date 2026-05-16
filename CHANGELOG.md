# Changelog

All notable changes to agent-memory-stack. This project is **early
(v0.1)**: the memory model is stable, but file layout and tooling may
still change. The protocol is versioned independently of the repo (see
`PROTOCOL.md`); pin a protocol version if you build on it.

Format loosely follows Keep a Changelog. Dates are ISO.

## [Unreleased]

Protocol version: **1** (unchanged , all changes below are additive or
documentation).

### Added
- `QUICKSTART.md` , a zero-dependency path to a working compounding stack
  in ~15 minutes, ending with an explicit acceptance test.
- `install.sh` , idempotent, dependency-free scaffolder for the Core tier
  (never overwrites your `identity.md` / `USER.md` / `distilled-memory.md`).
- `distillation.md` , the keep/drop contract, cadence, the reference
  distillation prompt, and a worked before/after. The engine of the stack.
- `examples/distilled-memory.md` , the shape of layer 4.
- `examples/loop-walkthrough.md` , the compounding loop made concrete
  across three sessions, with stateless-agent contrast.
- Protocol versioning: `PROTOCOL.md` now carries a version and a
  patch/minor/major stability contract so adopters can pin it.

### Changed
- Implementation guides split into **Core (zero dependencies)** vs
  **Optional automation**. The core stack now stands entirely alone , no
  other repos required; hooks/cron/oneshot are an explicitly optional
  hands-off upgrade.
- README re-led on the outcome (an agent that stops re-asking) rather than
  the layer count. Model reframed as four core layers + two optional bridge
  layers, with working memory named as the substrate, not a configured
  layer.
- `PROTOCOL.md` declared the single source of truth for read/write
  behavior; README tables are summaries of it.

## [0.1.0] , 2026-05

### Added
- Initial six-layer model, README, `PROTOCOL.md`, Claude Code and Codex
  implementation guides, and `identity.md` / `USER.md` / `session-log.md`
  examples.
