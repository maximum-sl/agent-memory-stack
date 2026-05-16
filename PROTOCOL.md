# PROTOCOL.md

**Protocol version: 1**

If you are an agent operating in a project that uses agent-memory-stack,
this file describes what to read, when to read it, and what to write,
per layer. This file is the source of truth for read/write behavior; any
table elsewhere (README, implementation guides) is a summary of it.

## Versioning

The protocol is versioned so adopters can target a stable contract. A
project can state "agent-memory-stack protocol v1" and rely on the read/write
rules below not changing under it.

- **Patch** (1 → 1, wording only): clarifications, no behavior change.
- **Minor** (1 → 1.x): additive , a new optional layer or rule that does
  not change existing behavior. Existing v1 setups keep working unchanged.
- **Major** (1 → 2): a breaking change to where something is read/written
  or when. Documented in `CHANGELOG.md` with a migration note.

If your project pins a version, check `CHANGELOG.md` before adopting a
higher one.

## Conventions

- Session log files live in `sessions/YYYY-MM-DD.md`. Override with the
  `AGENT_MEMORY_HOME` environment variable if your project stores them
  elsewhere.
- "Today's date" is the local-time date when the session opens.
- "Yesterday's date" is the most recent date with a non-empty session
  log. In practice this is usually the literal previous calendar day,
  but may be older if the user took a break.
- Layers 5-6 (Vault, Wiki) only apply if the project has a personal
  note system. If there's no vault, the protocol stops at layer 4.

## Layer 1: Identity

- Read the identity file (or platform-equivalent system prompt) at
  session start.
- Apply throughout the session.
- Do not modify without explicit user permission.

## Layer 2: Working memory

- This is your live conversation context, not a file.
- No specific protocol. This is the medium other layers feed into.

## Layer 3: Session log

- At session start: open or create `sessions/YYYY-MM-DD.md` for today's
  date. Use the shape from `examples/session-log.md`.
- At session start: read `sessions/{yesterday}.md` if it exists. Pay
  attention to its `### Open threads` and `### Pending user asks`
  sections , these are the bridge from yesterday.
- Throughout the session: update today's file incrementally. As soon
  as a deliverable ships, a decision is made, or an open thread
  surfaces, log it. Don't wait for end-of-session.
- Before context compaction: write a structured 7-section snapshot
  (Goal, Constraints & Preferences, Progress, Key Decisions, Relevant
  Files, Open Threads, Critical Context) to today's file BEFORE any
  compaction trigger fires.

## Layer 4: Distilled memory

- At session start: read `distilled-memory.md` if it exists. Treat as
  ambient durable context, not as active task state.
- Do not modify during a session. The distilled file is updated by a
  periodic compression process, not by the live agent.

## Layer 5: Vault (raw human notes)

- When the task makes it relevant: read from the user's vault. Common
  patterns: search by tag, scan recent notes, look at the inbox folder.
- Write back only with explicit permission, or when executing an
  in-vault directive (e.g., a note that contains `Claude - draft a
  tweet about X`).
- Never delete or overwrite vault content without explicit permission.

## Layer 6: Wiki (curated)

- When you need authoritative context on a specific entity (person,
  company, concept, product): query the wiki by entity name.
- Treat wiki content as compiled knowledge. It has been written
  deliberately and integrated across sources.
- Update only via explicit ingest or rebuild operations, never as a
  side effect of regular session work. Ingest takes a raw source and
  updates relevant entity pages, including cross-references and any
  contradiction notes.

## Layer-by-layer summary

| Layer | When to read | When to write |
|---|---|---|
| 1. Identity | Session start | Manual edits only |
| 2. Working | Continuous | Continuous |
| 3. Session log | Session start (yesterday's), continuous (today's) | Incrementally during session, structured snapshot before compaction |
| 4. Distilled | Session start | Periodic compression, not the live agent |
| 5. Vault | When task-relevant | With explicit permission |
| 6. Wiki | When entity-relevant | Explicit ingest operations |
