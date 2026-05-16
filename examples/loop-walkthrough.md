# Loop walkthrough , watching information survive

The whole value of this stack is the compounding loop: a thing learned in
one session is used in a later one without you re-explaining it. This is
that loop made concrete, across three sessions, in the world of the other
examples (Echo, helping Alex, the daily digest cron + the Notion
marketplace side project).

For each session, "Without the stack" shows what a stateless agent would
have done , the re-asking and re-deriving the stack eliminates.

---

## Session 1 , Monday 2026-05-06

Alex: "Build a daily digest cron , HN + the Verge, summarized, to my
Desktop by 7am."

Echo builds it, and writes `sessions/2026-05-06.md` (see
`session-log.md`). The relevant residue:

- **Decision:** Haiku over Sonnet (cost); 7am (Alex wakes 6:30); two
  sources, Reddit deferred.
- **Open thread:** verify the watchdog actually picks the job up next tick.
- **Critical context:** the job uses subscription-auth oneshot , never
  reintroduce raw API-key `claude -p`.

Session ends. None of this is in any model's context anymore.

---

## Session 2 , Tuesday 2026-05-07 (next day)

A fresh session. Echo's heartbeat reads `sessions/2026-05-06.md` at start.

Alex: "Did the digest fire?"

**With the stack:** Echo already read yesterday's Open threads. It checks
the watchdog state, confirms the 7am run happened, and , unprompted ,
closes the open thread and asks the one Pending user ask from yesterday
("still want a skip mechanism for travel days?"). It does **not** ask what
the digest job is, what model it uses, or where output goes.

**Without the stack:** "What digest job? Can you remind me what it does and
how it's set up?" Alex re-explains the thing he specified yesterday.

New decision this session (skip-mechanism: yes, a `SKIP` file on Desktop)
gets logged to `sessions/2026-05-07.md`.

---

## (Two weeks pass. Distillation runs.)

A weekly pass compresses `sessions/2026-05-01..18` into
`distilled-memory.md` (see `distilled-memory.md`). The digest decisions and
the subscription-auth rule survive as terse standing rules. The individual
session logs still exist, but the durable facts are now in the small
always-loaded file.

---

## Session 3 , Monday 2026-05-19 (two weeks later)

Brand new session. Yesterday's log is about something unrelated. But the
heartbeat loads `distilled-memory.md`.

Alex: "Add a second daily job , a competitor-news digest."

**With the stack:** Echo proposes it on Haiku, subscription-auth, output to
Desktop, and , without being told , says "weekday competitor digest, but
your side-project work stays weekend-only so I'm not touching that
schedule." It applied three things it was never re-told this session: the
cost default, the auth rule, and the weekday/weekend boundary. All from
distilled memory.

**Without the stack:** Echo picks Sonnet, suggests API keys for
reliability, and offers to also "knock out some marketplace tasks while
we're at it" , directly contradicting standing context, because none of it
survived. Alex re-corrects all three. Again.

---

## What this shows

The agent did not get smarter. The *system* did. Each session deposited
durable facts; distillation kept them small; the next session loaded them.
Session 3's competence is entirely inherited , that is the loop, and it is
the only thing in this stack that actually matters. Everything else
(layers, formats, automation) exists to keep this loop cheap and reliable
as it runs for months.
