# Distilled memory

> Layer 4 example. This is the shape that matters most and the one people
> get wrong. It is **rules, not narrative**: terse, durable, deduplicated,
> capped (~3KB). It is rewritten periodically from session logs, never
> appended to during a live session. See `../distillation.md` for the
> keep/drop contract that produces a file like this.
>
> This example continues the world of `session-log.md` and `USER.md`
> (Echo, helping Alex Rivera, PM building a Notion template marketplace).

_Last distilled: 2026-05-19 (covers sessions 2026-05-01 → 2026-05-18)_

## Standing decisions

- Autonomous jobs bill subscription auth, never API credits. Any new
  recurring job uses the oneshot wrapper.
- Daily digest job: Haiku, two sources (HN + Verge), 7am, output to
  ~/Desktop. Reddit was evaluated and deferred, do not re-propose without
  a new reason.
- Side project (Notion marketplace) work happens on weekends only. Do not
  schedule or suggest it on weekdays.

## Constraints and preferences

- Concise over thorough. Long structured output only when the task earns it.
- Tuesdays/Thursdays are heavy meeting days , prefer async deliverables,
  no live-review asks on those days.
- Never use em dashes in prose.

## Durable context

- Alex owns the activation funnel; "the metric" with no qualifier means
  activation rate, not signup count.
- The marketplace is pre-revenue, building in public; framing for it should
  assume an audience-building goal, not direct monetization yet.

## Corrections and lessons

- Digest output is written by the script, not the agent , the agent never
  has the file content; don't claim to have "reviewed" it.
- A cron set faster than the watchdog tick does not run faster; match
  cadence to the trigger before promising a frequency.

<!-- Cap: keep this under ~3KB. When it grows past that, the next
distillation pass must merge and drop, not extend. Resolved threads and
one-off task mechanics do not belong here , they stay in session logs. -->
