#!/usr/bin/env bash
# Installs the Hiberno-English voice pack for Claude Code.
#
# Two parts:
#   1. The language  — an output style for Claude's conversational replies.
#   2. The spinner   — Irish loading verbs, pulled at install time from
#                      tabman83/claude-code-spinner-verbs-irish (MIT). His work
#                      stays in his repo; we fetch the JSON data and merge it
#                      ourselves rather than piping a third-party script.
#
# The spinner step is best-effort: if his repo can't be reached, the language
# still installs and the spinner is skipped with a note. Your settings.json is
# backed up before any change, and nothing else in it is touched.
set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/brgan-wp/claude-code-hiberno-english/master"
SPINNER_RAW="https://raw.githubusercontent.com/tabman83/claude-code-spinner-verbs-irish/master/spinner-verbs.json"

CLAUDE_DIR="${HOME}/.claude"
STYLE_DIR="${CLAUDE_DIR}/output-styles"
STYLE_FILE="hiberno-english.md"
SETTINGS="${CLAUDE_DIR}/settings.json"

mkdir -p "${STYLE_DIR}"

# --- Part 1: the language (output style) ------------------------------------
# Prefer a local checkout if we're running from inside the repo.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
if [ -n "${SCRIPT_DIR}" ] && [ -f "${SCRIPT_DIR}/output-styles/${STYLE_FILE}" ]; then
  cp "${SCRIPT_DIR}/output-styles/${STYLE_FILE}" "${STYLE_DIR}/${STYLE_FILE}"
  echo "[1/2] Language installed from local checkout: ${STYLE_DIR}/${STYLE_FILE}"
else
  curl -fsSL "${REPO_RAW}/output-styles/${STYLE_FILE}" -o "${STYLE_DIR}/${STYLE_FILE}"
  echo "[1/2] Language downloaded and installed: ${STYLE_DIR}/${STYLE_FILE}"
fi

# --- Part 2: the spinner (pulled from tabman83's pack, then merged by us) ----
# Pick a JSON-capable merger. python3 is near-universal; jq is the fallback.
MERGER=""
if command -v python3 >/dev/null 2>&1; then MERGER="python3"
elif command -v jq    >/dev/null 2>&1; then MERGER="jq"
fi

VERBS_TMP="$(mktemp)"
trap 'rm -f "${VERBS_TMP}"' EXIT

if [ -z "${MERGER}" ]; then
  echo "[2/2] Spinner skipped: neither python3 nor jq is available to merge settings.json safely."
  echo "      The language is installed and ready. To add the spinner manually, see:"
  echo "      https://github.com/tabman83/claude-code-spinner-verbs-irish"
elif ! curl -fsSL "${SPINNER_RAW}" -o "${VERBS_TMP}"; then
  echo "[2/2] Spinner skipped: couldn't reach tabman83's pack (offline, or his repo moved)."
  echo "      The language is installed and ready. Re-run this installer later to add the spinner."
else
  # Back up settings.json before touching it.
  if [ -f "${SETTINGS}" ]; then
    cp "${SETTINGS}" "${SETTINGS}.bak.$(date +%Y%m%d-%H%M%S)"
  fi

  if [ "${MERGER}" = "python3" ]; then
    SETTINGS="${SETTINGS}" VERBS_TMP="${VERBS_TMP}" python3 - <<'PY'
import json, os, sys

settings_path = os.environ["SETTINGS"]
verbs_path = os.environ["VERBS_TMP"]

with open(verbs_path, encoding="utf-8") as f:
    fetched = json.load(f)

# tabman83's pack ships a settings snippet: {"spinnerVerbs": {"mode": ..., "verbs": [...]}}.
# Be tolerant of a bare ["verb", ...] array too, in case the format ever changes.
if isinstance(fetched, dict) and isinstance(fetched.get("spinnerVerbs"), dict):
    spinner = fetched["spinnerVerbs"]
elif isinstance(fetched, list):
    spinner = {"mode": "replace", "verbs": fetched}
else:
    sys.exit("Fetched spinner pack was not in a recognised shape; leaving settings.json untouched.")

verbs = spinner.get("verbs", [])
if not isinstance(verbs, list) or not verbs:
    sys.exit("Fetched spinner pack had no verbs; leaving settings.json untouched.")

settings = {}
if os.path.exists(settings_path):
    with open(settings_path, encoding="utf-8") as f:
        text = f.read().strip()
    if text:
        settings = json.loads(text)  # plain JSON; a parse error here aborts before any write

# Merge our two keys, preserving everything else the user has.
settings["spinnerVerbs"] = spinner
settings["outputStyle"] = "Hiberno-English"

with open(settings_path, "w", encoding="utf-8") as f:
    json.dump(settings, f, indent=2, ensure_ascii=False)
    f.write("\n")

print(f"[2/2] Spinner installed ({len(verbs)} Irish verbs, mode '{spinner.get('mode','replace')}') and outputStyle set.")
PY
  else
    # jq fallback: same merge, same preservation of existing keys.
    # Take his .spinnerVerbs object wholesale; tolerate a bare array too.
    [ -f "${SETTINGS}" ] || echo '{}' > "${SETTINGS}"
    TMP_OUT="$(mktemp)"
    jq --slurpfile v "${VERBS_TMP}" \
      '($v[0]) as $p
       | (if ($p|type) == "object" and ($p.spinnerVerbs|type) == "object" then $p.spinnerVerbs
          elif ($p|type) == "array" then {mode:"replace", verbs:$p}
          else error("unrecognised spinner pack shape") end) as $sv
       | .spinnerVerbs = $sv | .outputStyle = "Hiberno-English"' \
      "${SETTINGS}" > "${TMP_OUT}" && mv "${TMP_OUT}" "${SETTINGS}"
    echo "[2/2] Spinner installed and outputStyle set (via jq)."
  fi
fi

echo
echo "Done. The voice is live in your next Claude Code session."
echo "(Spinner verbs and output style both load at session start, so restart claude to see them.)"
echo
echo "Switch the language off any time with:  /output-style default"
