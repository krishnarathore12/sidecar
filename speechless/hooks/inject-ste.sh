#!/usr/bin/env bash
# Emit the speechless rules as session context.
#
# A skill only fires when the model decides it is relevant, so it cannot
# deliver "apply to everything, always." This hook loads the rules once per
# session instead, which is what always-on requires.

set -euo pipefail

SKILL="${CLAUDE_PLUGIN_ROOT:-}/skills/speechless/SKILL.md"
[ -f "$SKILL" ] || exit 0

printf '%s\n\n' "# Response style: Simplified Technical English (speechless plugin)"
printf '%s\n\n' "Apply the following to EVERY response in this session, including short replies."

# Print the skill body, dropping the YAML frontmatter between the first two --- lines.
awk 'BEGIN { fences = 0 }
     /^---$/ && fences < 2 { fences++; next }
     fences >= 2 { print }' "$SKILL"
