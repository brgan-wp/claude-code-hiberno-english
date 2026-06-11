# claude-code-hiberno-english

Rules for working in this repo:

- **GLOSSARY.md is the source of truth.** Any change to the voice goes there first; `output-styles/hiberno-english.md` is then updated to match. Never let the two drift.
- **No stage-Irish, ever.** The anti-glossary in GLOSSARY.md is a hard list. If a contribution adds "begorrah"-register content or eye-dialect spelling, reject it.
- **The chat-only boundary is load-bearing.** The output style must always contain the hard boundary section (voice never enters code, files, commits, or drafted messages). Don't weaken it for colour.
- Keep `install.sh` to exactly one job: copy one file to `~/.claude/output-styles/`. No settings.json edits, no extra downloads.
