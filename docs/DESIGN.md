# Design — claude-code-hiberno-english

*2026-06-11. Brainstormed and approved in session (S—, hiberno-english-pack).*

## What

A public, installable pack that makes Claude Code's **conversational replies** use authentic Hiberno-English (Dublin lean). Companion to `claude-code-spinner-verbs-irish`.

## Decisions

- **Scope: chat only.** The voice never enters artifacts — code, commits, file contents, or anything drafted to be sent as the user. This boundary is written into the style itself, because the style is the only thing the model sees.
- **Mechanism: Claude Code output style** (`~/.claude/output-styles/hiberno-english.md`, activated with `/output-style`). One file, reversible with `/output-style default`. Rejected: appending to users' CLAUDE.md (messy, hard to uninstall); a full plugin (5x the build, wrong mechanism for voice).
- **GLOSSARY.md is the source of truth.** Grammar, vocabulary, discourse habits, anti-glossary. The output style is derived from it; retuning = edit glossary first, then style. (Same rules-doc pattern as the maintainer's other projects.)
- **Authenticity = grammar over slang.** The after-perfect, clause-final *so*, *amn't*, clefting do the work; vocabulary is seasoning. Anti-glossary bans stage-Irish (begorrah, top o' the mornin', eye-dialect spelling) and over-density.
- **Audience: public repo**, installed locally from the checkout on the maintainer's machine.

## Components

| File | Purpose |
|---|---|
| `GLOSSARY.md` | The reference. Edit here first. |
| `output-styles/hiberno-english.md` | The deliverable — derived from the glossary, carries the chat-only hard boundary. |
| `install.sh` | Copies the one style file to `~/.claude/output-styles/` (local checkout preferred, curl fallback). |
| `README.md` | Pitch, install, uninstall, retuning. |

## Testing

Manual: activate the style, hold a conversation, confirm (a) the register lands without stage-Irish tells, (b) a file written mid-conversation contains none of the voice, (c) `/output-style default` fully reverts.
