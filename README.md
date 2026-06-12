# Claude Code — Hiberno-English

Make Claude Code *talk* like it's from Dublin. Not "top o' the mornin'" — the real thing.

A two-part voice pack for Claude Code:

1. **The language** — an [output style](https://docs.anthropic.com/en/docs/claude-code) that gives Claude's conversational replies an authentic Hiberno-English register, built from a [linguistically-informed glossary](GLOSSARY.md) of the grammar that actually does the work: the after-perfect ("I'm after finding the bug"), clause-final *so* ("I'll restart it so"), *amn't*, *give out*, *your man*, and friends.
2. **The spinner** — the Irish loading verbs from [tabman83/claude-code-spinner-verbs-irish](https://github.com/tabman83/claude-code-spinner-verbs-irish), so "Churning…" becomes "Wreckin' me head…". The installer **pulls his pack at install time**; his verbs stay in his repo (see [CREDITS.md](CREDITS.md)). If his repo is unreachable, the language still installs and the spinner is skipped.

> **Sure look, the build's grand — all green. It was the config that was at fault, not your code. Will I push it so?**

**The voice is chat-only by design.** The style carries a hard boundary: code, commits, file contents, emails, and anything drafted to be sent stay exactly as Claude would normally write them. It changes how Claude talks to you, not what it builds for you.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/brgan-wp/claude-code-hiberno-english/master/install.sh | bash
```

(Or, sensibly, read `install.sh` first — it's commented and shows exactly what it touches.)

The installer:
- copies the output style to `~/.claude/output-styles/`,
- pulls tabman83's spinner verbs and merges them into `~/.claude/settings.json` (backed up first, nothing else touched),
- sets `outputStyle` so the language is active on next launch.

Both load at session start, so **restart Claude Code** to see them. That's it — no `/output-style` step needed.

### Manual install (language only)

Copy `output-styles/hiberno-english.md` to `~/.claude/output-styles/` and run `/output-style Hiberno-English`. For the spinner on its own, install [tabman83's pack](https://github.com/tabman83/claude-code-spinner-verbs-irish) directly.

## Uninstall

```
/output-style default
```

and delete `~/.claude/output-styles/hiberno-english.md` if you want it fully gone.

## Retuning the voice

[`GLOSSARY.md`](GLOSSARY.md) is the source of truth — grammar, vocabulary, discourse habits, and an anti-glossary of stage-Irish tells. The output style is derived from it. To change the voice, edit the glossary, then update the style to match.

## What "authentic" means here

The pack leans on Hiberno-English **grammar** rather than slang density, because that's what makes real Irish speech sound Irish. A reply using the after-perfect and zero slang reads more Dublin than one stuffed with "deadly". The anti-glossary bans the Hollywood register outright. The *amn't* entry is there on principle: it's standard Irish English that autocorrect has been quietly suppressing for years.

## License

MIT
