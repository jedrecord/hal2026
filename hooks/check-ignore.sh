#!/usr/bin/env bash
# .claudeignore hook — blocks Claude from accessing files matching patterns in .claudeignore
# Uses .gitignore syntax via git check-ignore

# Read the JSON input from Claude Code
INPUT=$(cat)

# Extract the file path or directory path from the tool input.
# Different tools use 'file_path' or 'path' keys.
TARGET_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty')

# If no path is identified or .claudeignore doesn't exist, proceed as normal.
IGNORE_FILE="$CLAUDE_PROJECT_DIR/.claudeignore"
if [ -z "$TARGET_PATH" ] || [ ! -f "$IGNORE_FILE" ]; then
  exit 0
fi

# Use git check-ignore logic to simulate .gitignore behavior against the .claudeignore file.
# --no-index allows checking files that are not tracked by git.
if git check-ignore --quiet --no-index --exclude-from="$IGNORE_FILE" "$TARGET_PATH"; then
  # If matched, write a reason to stderr and exit with code 2 to block the tool.
  echo "Access to '$TARGET_PATH' is blocked by your .claudeignore file." >&2
  exit 2
fi

exit 0
