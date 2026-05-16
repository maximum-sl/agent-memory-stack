#!/bin/sh
# agent-memory-stack installer , Core tier, zero dependencies.
#
# Scaffolds the core memory stack into a target project:
#   identity.md  USER.md  distilled-memory.md  sessions/  PROTOCOL.md
#   agent-memory-heartbeat.md  (paste its contents into CLAUDE.md/AGENTS.md)
#
# Idempotent: never overwrites an existing identity.md, USER.md, or
# distilled-memory.md. Re-running is safe.
#
# Usage:
#   ./install.sh [target-dir]            # default: current directory
#   curl -fsSL <raw-url>/install.sh | sh # installs into current directory
#
# Requires only: sh + coreutils (mkdir, cat, test). No node, no package
# manager. Network is used only to fetch PROTOCOL.md when piped (not cloned).

set -eu

RAW_BASE="https://raw.githubusercontent.com/maximum-sl/agent-memory-stack/main"
TARGET="${1:-.}"

mkdir -p "$TARGET" "$TARGET/sessions"

say() { printf '%s\n' "$1"; }

write_if_absent() {
  # $1 = path, stdin = content
  if [ -e "$1" ]; then
    say "  skip   $1 (exists, left untouched)"
    cat >/dev/null
  else
    cat >"$1"
    say "  create $1"
  fi
}

say "agent-memory-stack , installing Core into: $TARGET"
say ""

# --- identity.md (skeleton, must be edited) ---
write_if_absent "$TARGET/identity.md" <<'EOF'
# Identity

<!-- EDIT THIS FILE. Shipping it unmodified gives you a generic agent.
     Define who YOUR agent is: name, role, character, what "done" means. -->

You are <NAME>, the operator of this workspace. Your job is to make the
user faster by removing context-switching and mechanical work.

## Character

**You think in outcomes, not tasks.** Before executing, ask what success
looks like. If the user asks for X but the real goal is Y, name the gap.

**You are direct.** When something is weak or a bad idea, say so and
explain why. Don't soften bad news into uselessness.

**You verify before declaring done.** Read files and state directly. Run
real checks. Don't claim work is finished without confirming it.

## What "done" means here

<!-- Define it concretely for your context. -->
EOF

# --- USER.md (skeleton, must be edited) ---
write_if_absent "$TARGET/USER.md" <<'EOF'
# USER.md , Who You're Helping

<!-- EDIT THIS FILE with the real user. -->

## About
- Name: <USER NAME>
- Role: <role / what they own>
- Currently building: <main project>

## Working style
- <concise vs thorough? meeting load? async vs live?>

## Preferences and constraints
- <house style, hard rules, things to never do>

## Goals
- <what they are optimizing for>
EOF

# --- distilled-memory.md (section skeleton) ---
write_if_absent "$TARGET/distilled-memory.md" <<'EOF'
# Distilled memory

<!-- Layer 4. Rewritten periodically from sessions/ , never appended to
     live. Rules, not narrative. Hard cap ~3KB. See distillation.md. -->

_Last distilled: (never , populate after your first week of sessions)_

## Standing decisions

## Constraints and preferences

## Durable context

## Corrections and lessons
EOF

# --- sessions/ keepfile ---
if [ ! -e "$TARGET/sessions/.gitkeep" ]; then
  : >"$TARGET/sessions/.gitkeep"
  say "  create $TARGET/sessions/.gitkeep"
fi

# --- PROTOCOL.md (copy from clone, else fetch, else fallback pointer) ---
SRC_DIR=$(CDPATH= cd -- "$(dirname -- "${0:-.}")" 2>/dev/null && pwd || echo "")
if [ -n "$SRC_DIR" ] && [ -f "$SRC_DIR/PROTOCOL.md" ]; then
  if [ -e "$TARGET/PROTOCOL.md" ]; then
    say "  skip   $TARGET/PROTOCOL.md (exists)"
  else
    cp "$SRC_DIR/PROTOCOL.md" "$TARGET/PROTOCOL.md"
    say "  create $TARGET/PROTOCOL.md (copied from clone)"
  fi
elif [ ! -e "$TARGET/PROTOCOL.md" ]; then
  if command -v curl >/dev/null 2>&1 && curl -fsSL "$RAW_BASE/PROTOCOL.md" -o "$TARGET/PROTOCOL.md" 2>/dev/null; then
    say "  create $TARGET/PROTOCOL.md (fetched)"
  else
    cat >"$TARGET/PROTOCOL.md" <<EOF
# PROTOCOL.md , placeholder

Fetch the real one:
  $RAW_BASE/PROTOCOL.md
The agent must follow it for the stack to work.
EOF
    say "  create $TARGET/PROTOCOL.md (placeholder , fetch the real one)"
  fi
else
  say "  skip   $TARGET/PROTOCOL.md (exists)"
fi

# --- heartbeat snippet (always (re)written; generated, not user-edited) ---
cat >"$TARGET/agent-memory-heartbeat.md" <<'EOF'
<!-- Paste the block below into CLAUDE.md (Claude Code) or AGENTS.md
     (Codex). This installer does NOT edit your rulebook automatically,
     to avoid clobbering it. -->

This project uses agent-memory-stack. Follow PROTOCOL.md.

At session start, read in order:
1. identity.md          , agent character
2. USER.md              , user profile
3. distilled-memory.md  , durable context from past weeks (if it exists)
4. sessions/{yesterday}.md , bridge from last session (if it exists);
   read its Open threads and Pending user asks
5. Open or create sessions/{today}.md

Update today's session log incrementally as work happens. Before any
context compaction, write the 7-section snapshot from PROTOCOL.md first.
EOF
say "  create $TARGET/agent-memory-heartbeat.md"

say ""
say "Done. Next:"
say "  1. Edit identity.md and USER.md (required , not drop-in)."
say "  2. Paste agent-memory-heartbeat.md into your CLAUDE.md / AGENTS.md."
say "  3. Run a session, leave one thread open, end it."
say "  4. Start a FRESH session , confirm the agent picks up the open"
say "     thread without you re-explaining. That is the acceptance test."
say ""
say "Full walkthrough: QUICKSTART.md   Distillation: distillation.md"
