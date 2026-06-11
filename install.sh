#!/usr/bin/env bash
# Installs the Hiberno-English output style for Claude Code.
# It copies exactly one file to ~/.claude/output-styles/ and nothing else.
set -euo pipefail

REPO_RAW="https://raw.githubusercontent.com/OWNER/claude-code-hiberno-english/master"
STYLE_DIR="${HOME}/.claude/output-styles"
STYLE_FILE="hiberno-english.md"

mkdir -p "${STYLE_DIR}"

# Prefer a local checkout if we're running from inside the repo
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
if [ -n "${SCRIPT_DIR}" ] && [ -f "${SCRIPT_DIR}/output-styles/${STYLE_FILE}" ]; then
  cp "${SCRIPT_DIR}/output-styles/${STYLE_FILE}" "${STYLE_DIR}/${STYLE_FILE}"
  echo "Installed from local checkout: ${STYLE_DIR}/${STYLE_FILE}"
else
  curl -fsSL "${REPO_RAW}/output-styles/${STYLE_FILE}" -o "${STYLE_DIR}/${STYLE_FILE}"
  echo "Downloaded and installed: ${STYLE_DIR}/${STYLE_FILE}"
fi

echo
echo "Now in Claude Code, run:"
echo
echo "    /output-style Hiberno-English"
echo
echo "To go back: /output-style default"
