# agent-memory-stack

**An agent that stops re-asking what you've answered and re-deriving what
you've decided.** A markdown-only memory architecture for long-running CLI
agents, organized by time horizon and read pattern so knowledge compounds
across sessions instead of resetting.

Zero dependencies for the core. Works on any OS, with Claude Code, Codex,
or any agent that reads a rulebook file at session start.

> **Status:** early (v0.1). The model is stable; file layout and tooling
> may still change. The protocol is versioned (see `PROTOCOL.md`) so you
> can pin a contract. Changes are tracked in `CHANGELOG.md`.

**Start here:** [`QUICKSTART.md`](QUICKSTART.md) , a working compounding
stack in ~15 minutes, no dependencies. Then
[`examples/loop-walkthrough.md`](examples/loop-walkthrough.md) to see the
payoff, and [`distillation.md`](distillation.md) for the engine that makes
it compound.

## The problem

Every long-running agent eventually loses information that mattered. Either
context fills up and a built-in summarizer compresses it lossily, or the
session ends and the next session starts blind. Either way, the agent
re-asks questions you've already answered and re-derives decisions you've
already made.

This stack gives every piece of information a defined home, a defined
read/write pattern, and a defined time when it loads. The agent always
knows where to write something and where to read it back. The internal
summarizer stops being the load-bearing component.

## The model

Four agent-internal layers, plus two optional layers that bridge to a
personal note system. Working memory (the live conversation) is the
substrate the other layers feed, not a layer you configure , so in
practice you maintain **three core files** (identity, session log,
distilled memory) and, optionally, a vault and wiki.

Layers are organized by **time horizon** (how recent is the information?)
and **read pattern** (when does the agent look at it?). Each answers a
different question:

| # | Layer | Question | Read |
|---|---|---|---|
| 1 | Identity | Who are you? Who are you talking to? | Always at session start |
| 2 | Working memory | What are we doing right now? | Continuous (it's the live conversation) |
| 3 | Session log | What happened this session and the last one? | Session start (read), continuously (write) |
| 4 | Distilled memory | What's durable from past weeks? | Session start |
| 5 | Vault (raw human notes) | What is the user capturing, bookmarking, writing? | When relevant to the task |
| 6 | Wiki (curated) | What do I authoritatively know about specific people, companies, concepts? | Queried on demand |

Layers 1-4 are agent-internal. Layers 5-6 bridge to human-authored
knowledge and only apply if you maintain a personal note system
(Obsidian, Notion, plain markdown folder). Without one, an agent
operates entirely on layers 1-4. Together they cover everything from
"who am I" to "what does the user think about Topic Z."

## The six layers

### 1. Identity

**Question:** Who is the agent? Who is the user? What are the rules of
engagement?

The static or near-static foundation. System prompt material. Personality,
behavioral principles, communication style on the agent side. User profile,
preferences, role, goals on the user side.

**Read:** Always loaded at session start. Effectively a system prompt.
**Write:** Manually edited as preferences and roles evolve.
**Format:** Markdown.

### 2. Working memory

**Question:** What are we doing right now?

The live conversation context window. The agent is always reading and
writing to this layer. That's what an agent IS. Mentioned here for
completeness, not because it needs templating.

**Read:** Continuous.
**Write:** Continuous.
**Format:** Whatever the agent platform uses internally.

### 3. Session log

**Question:** What happened during this session, and the previous one?

A markdown file per day. Updated incrementally during the session as
deliverables ship and decisions get made. Read at the start of the next
session as bridge context. The file has a defined shape: active task,
deliverables, decisions, open threads.

**Read:** At session start (yesterday's), continuous reference (today's).
**Write:** Incrementally during the session, plus a structured snapshot
before context compaction.
**Format:** `sessions/YYYY-MM-DD.md`, with numbered session blocks.

### 4. Distilled memory

**Question:** What's durably true from the past weeks?

A short, hand-curated or LLM-compressed summary of decisions, patterns,
and standing context that have proven durable across many sessions. Capped
at a small size (a few KB) so it fits in the always-loaded context budget
without crowding out other layers.

**Read:** At session start.
**Write:** Periodically (cron job, manual review, or both) by compressing
older session logs into rules, decisions, and standing context.
**Format:** Single markdown file with thematic sections.

### 5. Vault (raw human notes)

**Question:** What is the user capturing, bookmarking, journaling?

The user's personal note system. The bridge between what the user is
thinking when they're not at the keyboard and what the agent knows.

**Recommended: Obsidian.** Markdown-native, file-based, free, and has an
`obsidian` CLI for agent interaction. The model doesn't depend on
Obsidian, but Obsidian fits this stack with the least friction.

**Read:** When relevant to the current task. Specific access patterns
include: read recent notes for context, search by tag, scan inbox folder.
**Write:** The agent occasionally writes back into the vault (filed
inbox notes, executed `-claude` directives, drafted responses).
**Format:** Whatever the vault tool uses. For Obsidian, plain markdown
files with optional YAML frontmatter.

### 6. Wiki (curated)

**Question:** What do I authoritatively know about specific people,
companies, concepts, products?

An LLM-maintained knowledge graph layered on top of the vault. Raw sources
(articles, transcripts, meeting notes) get ingested. Entity pages
(people.md, companies.md, products/X.md) get updated, cross-linked, and
de-duplicated. Inspired by Karpathy's LLM Wiki pattern.

The wiki is not merely retrieval. It's compiled and maintained
knowledge: the LLM integrates each new source into existing entity
pages at ingest time, updates cross-references, and can flag
contradictions. Synthesis happens at compile time, not query time. Each
read returns pre-synthesized knowledge rather than re-derived chunks.

**Read:** Queried by entity name when the agent needs authoritative
context on a specific subject.
**Write:** By the agent during ingest commands, periodic rebuilds, and
contradiction-flagging passes.
**Format:** Markdown entity pages inside the vault, with backlinks. Lives
naturally inside Obsidian as a `wiki/` folder.

## Standing on

This stack synthesizes existing patterns. Specific debts:

- **MemGPT (Yang et al., 2023) and the Letta product** for the
  tiered-memory architecture inspired by OS virtual memory. The
  "always-loaded vs queried" distinction comes from there.
- **Generative Agents (Park et al., Stanford 2023)** for the reflection
  pattern that informs layer 4 (distilled memory). Distillation is a
  flattened cousin of their reflection step.
- **Karpathy's LLM Wiki** for the entire layer 6 concept. The compilation
  metaphor (raw sources → wiki via LLM compilation) is his framing.
- **Personal knowledge management** (Obsidian-and-similar systems) for
  layer 5. The agent-readable vault concept comes from this lineage.

## What this stack adds

Layered memory architectures exist (MemGPT, Generative Agents). PKM-LLM
bridges exist (Karpathy's wiki and others). Daily session logging exists
(every productivity system). What hasn't existed is a single
operator-friendly system that combines them with clean boundaries and
explicit read rules.

Specifically:

- **Each layer has a defined home, role, and read pattern.** No overlap,
  no ambiguity about where a given piece of information should go.
- **Time-horizon decomposition.** Layers organize by when information
  becomes relevant (now / today / weeks / forever) rather than by
  storage tier. Easier for an operator to reason about.
- **Explicit "when to read" rules.** Most memory writeups describe what
  to store. This one specifies when each layer gets loaded, which is
  the harder design question.
- **Agent-human bridge.** Layers 5 and 6 let the agent read from the
  user's personal notes and maintain a curated wiki the user can also
  browse. The agent isn't sealed off from how the user actually thinks.
- **Concrete and runnable.** File paths, hook configurations for Claude
  Code, manual-instruction patterns for Codex, templates per layer.
  Wire it up in an afternoon.

## Implementations

How to wire this stack up depends on your CLI agent platform.

- [Claude Code](implementations/claude-code.md) , uses `CLAUDE.md` for
  layer 1, hooks for automatic layer 3 / 4 maintenance, the `obsidian`
  CLI for layers 5-6.
- [Codex](implementations/codex.md) , uses `AGENTS.md` for layer 1,
  manual instructions in `AGENTS.md` for layers 3-4 (no hooks system),
  same shell access pattern for layers 5-6.

## Examples

The `examples/` directory has three worked files showing the layers
where shape matters:

- [`examples/identity.md`](examples/identity.md) , layer 1 agent character
- [`examples/USER.md`](examples/USER.md) , layer 1 user profile
- [`examples/session-log.md`](examples/session-log.md) , layer 3
  daily session log with the pre-compact snapshot block

The other layers (working memory, distilled memory, vault, wiki) are
described in the model section above and don't need a separate file
to copy from.

## PROTOCOL.md

[`PROTOCOL.md`](PROTOCOL.md) is the agent-readable companion and the
**source of truth** for read/write behavior. The per-layer table above is
a summary of it; if they ever disagree, PROTOCOL.md wins. It is versioned
so a project can pin a contract. If you want a friend's agent to adopt this
stack, point it at PROTOCOL.md and the templates (or just run
`install.sh`).

## Known limitations

What this stack does not solve, in the current shape:

- **No queryable long-term retrieval layer.** Once distilled memory
  can't represent everything you've accumulated, you'll want RAG over
  your full markdown corpus. This stack doesn't include it as a
  first-class layer to keep the model markdown-only. Use any vector DB
  you prefer (ChromaDB, sqlite-vss, lancedb) on top of the markdown
  layers.
- **No archival.** Old session logs accumulate without rotation. After
  a year or two, this hurts both file listings and any retrieval
  system you layer on top. An archive cron isn't included, but is
  recommended.
- **No introspection.** When the agent makes a decision, you can't easily
  audit which layer was consulted or which retrieved chunks influenced
  the answer. Add a decision log if you need this.
- **No privacy/sensitivity tiers.** All layers are plaintext markdown. If
  you have sensitive data (financial, medical, client confidential), keep
  it outside this stack or build a separate encrypted tier.
- **Wiki has no provenance verification.** Layer 6 inherits Karpathy's
  LLM Wiki pattern's biggest weakness: the LLM can hallucinate during
  ingest, and there's no automatic mechanism to verify claims against
  source material. Mitigations: cite sources in entity pages, run
  periodic re-ingest with diff review.

## License

MIT. See [LICENSE](LICENSE).
