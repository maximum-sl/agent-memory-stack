# Distillation , the engine of the stack

Almost anyone can keep a daily log. Almost nobody distills it well, and
distillation is the layer that makes memory *compound* instead of just
*accumulate*. This is the part of the stack with the real edge, so it gets
its own document.

Distillation is the periodic rewrite of many session logs (layer 3) into
one small, durable file (layer 4) that is loaded every session. Get it
right and the agent inherits months of context for a few KB. Get it wrong
and you either lose decisions or blow the context budget.

## The contract

Distillation must satisfy all of these. They are not preferences.

1. **Rewrite, never append.** Each pass produces a fresh `distilled-memory.md`
   from the source logs plus the previous distilled file. Appending is how
   this file rots into an unbounded transcript.
2. **Capped, hard.** ~3KB (a few hundred lines max). The cap is load-bearing:
   this file is in the always-loaded context budget. If a pass would exceed
   the cap, it must merge and drop, not extend. The cap forces the judgment
   that makes distillation valuable.
3. **Rules, not narrative.** "Digest uses Haiku for cost; Reddit deferred"
   not "We discussed which model to use and decided...". Imperative,
   terminal, scannable.
4. **Idempotent.** Running it twice on the same inputs yields effectively
   the same file. If it doesn't, it's summarizing mood, not extracting
   facts.
5. **Deduplicated and current.** A later decision that supersedes an earlier
   one replaces it. The file reflects the present standing state, not the
   history of how it was reached.

## Keep vs drop

This is the entire skill. When in doubt, drop , the session logs still
exist; distilled memory is the small hot set, not the archive.

**Keep (durable):**
- Standing decisions that constrain future work ("subscription auth, never
  API credits").
- Preferences and constraints that recur ("concise over thorough";
  "weekends only for the side project").
- Corrections and lessons , things the agent got wrong and the rule that
  prevents repeating it. These are the highest-value lines in the file.
- Durable context , stable facts about the user, the domain, the projects
  ("'the metric' means activation rate").

**Drop (transactional):**
- Task mechanics and play-by-play ("created file X, ran command Y").
- Resolved open threads. Once closed, the outcome may be a kept decision;
  the thread itself is noise.
- Anything already implied by identity/USER files.
- Speculation, vibes, restated conversation. If it isn't a fact or a rule,
  it doesn't survive.

A useful test per candidate line: *will an agent two months from now make a
worse decision if it doesn't know this?* If no, drop it.

## Cadence

Weekly is the sane default. More often and there isn't enough new durable
signal to justify the pass. Less often and session logs pile up and the
pass gets lossy because there's too much to compress at once. Trigger it
on a schedule (automation tier) or on demand (Core , just ask).

## The distillation prompt

This is the reference instruction. It works as an on-demand ask or as the
body of a scheduled job:

> Read every `sessions/*.md` from the last two weeks and the current
> `distilled-memory.md`. Rewrite `distilled-memory.md` from scratch under
> these rules: keep only standing decisions, recurring constraints and
> preferences, corrections/lessons, and durable context. Drop task
> mechanics, resolved threads, and anything restating conversation. Express
> everything as terse imperative rules grouped under the existing section
> headings. If two items conflict, keep the most recent and delete the
> older. Hard cap ~3KB , if over, merge and cut, do not extend. Output the
> full file, not a diff.

## Worked before / after

**Input , two session log fragments:**

```
# 2026-05-06 / Session 1
Active task: build daily digest cron (HN + Verge → Desktop, 7am).
Decisions: Haiku not Sonnet (digest is simple, ~1/8 cost). 7am because
Alex wakes 6:30. Two sources for v1, Reddit deferred.
Open threads: verify watchdog picks up the job next tick.
Critical: job uses claude-oneshot (subscription auth) , never raw
`claude -p` with an API key.

# 2026-05-09 / Session 1
Active task: investigate why digest didn't arrive Thursday.
Found: watchdog tick is hourly; a 7:00 job set every_30m doesn't run
every 30m. Fixed schedule to every_24h. Verified Friday delivery.
Decisions: match cron cadence to the watchdog tick before promising a
frequency. Reddit still deferred (Alex confirmed not now).
```

**Output , the distilled lines those produce:**

```
## Standing decisions
- Daily digest: Haiku, HN + Verge, 7am, ~/Desktop, schedule every_24h.
  Reddit deferred (confirmed, do not re-propose without a new reason).
- Recurring jobs use subscription-auth oneshot, never raw API-key claude -p.

## Corrections and lessons
- A cron set faster than the watchdog tick does not run faster. Match
  cadence to the trigger before promising a frequency.
```

Five log paragraphs became four durable lines. The watchdog-pickup thread
vanished (resolved). The "1/8 cost" reasoning vanished (the decision is
what matters, not the derivation). The supersession (every_30m → every_24h)
was applied, not recorded as history. That compression, done with judgment,
is the engine. Everything else in this stack just keeps it cheap to run.
