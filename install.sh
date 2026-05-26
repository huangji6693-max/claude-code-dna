#!/usr/bin/env bash
# claude-code-dna — one-shot installer
# Usage: ./install.sh [--dry-run] [--no-backup]

set -euo pipefail

DRY=0
BACKUP=1
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY=1 ;;
    --no-backup) BACKUP=0 ;;
    -h|--help)
      cat <<EOF
claude-code-dna installer

Options:
  --dry-run     Show what would be copied without doing it
  --no-backup   Skip backing up existing files (dangerous)

What it does:
  1. Copies rules/*.md to ~/.claude/rules/ (backs up if exists)
  2. Copies memory-system/*.md to ~/.claude/rules/ (the memory-optimization doc is rule-shaped)
  3. Symlinks scripts/*.sh into ~/.claude/scripts/
  4. Prints a snippet to add to your CLAUDE.md for auto-loading
  5. Runs memory-health.sh as a smoke test
EOF
      exit 0 ;;
  esac
done

if [ -t 1 ]; then Y=$'\033[33m'; G=$'\033[32m'; C=$'\033[36m'; B=$'\033[1m'; N=$'\033[0m'; else Y=; G=; C=; B=; N=; fi

SRC="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
RULES_DST="$CLAUDE_HOME/rules"
SCRIPTS_DST="$CLAUDE_HOME/scripts"
TS="$(date +%Y%m%d-%H%M%S)"

echo "${C}${B}== claude-code-dna installer ==${N}"
echo "Source: $SRC"
echo "Target: $CLAUDE_HOME"
[ $DRY -eq 1 ] && echo "${Y}DRY-RUN mode — no files will be written${N}"
echo ""

run() {
  if [ $DRY -eq 1 ]; then echo "  [dry] $*"; else eval "$*"; fi
}

# Step 1: Ensure target dirs exist
echo "${C}1.${N} Ensuring target directories exist"
run "mkdir -p '$RULES_DST' '$SCRIPTS_DST'"

# Step 2: Copy rule files (with backup)
echo "${C}2.${N} Installing rules"
for f in "$SRC"/rules/*.md "$SRC"/memory-system/*.md; do
  [ -f "$f" ] || continue
  base="$(basename "$f")"
  dst="$RULES_DST/$base"
  if [ -e "$dst" ] && [ $BACKUP -eq 1 ]; then
    run "cp '$dst' '$dst.backup-$TS'"
    echo "  ${Y}backed up${N} $base → $base.backup-$TS"
  fi
  run "cp '$f' '$dst'"
  echo "  ${G}installed${N} $base"
done

# Step 3: Symlink scripts (so updates flow through)
echo "${C}3.${N} Linking scripts"
for f in "$SRC"/scripts/*.sh; do
  [ -f "$f" ] || continue
  base="$(basename "$f")"
  dst="$SCRIPTS_DST/$base"
  if [ -L "$dst" ] || [ -f "$dst" ]; then
    run "rm -f '$dst'"
  fi
  run "ln -s '$f' '$dst'"
  run "chmod +x '$f'"
  echo "  ${G}linked${N} $base"
done

# Step 4: Print CLAUDE.md snippet
echo ""
echo "${C}4.${N} Add this to your ${B}~/.claude/CLAUDE.md${N} (or project CLAUDE.md):"
echo ""
cat <<'SNIPPET'
@rules/karpathy-4-laws.md
@rules/operating-instincts.md
@rules/dna-routing-table.md
@rules/memory-optimization.md
SNIPPET
echo ""

# Step 5: Smoke test
echo "${C}5.${N} Smoke test"
if [ $DRY -eq 0 ] && [ -x "$SCRIPTS_DST/memory-health.sh" ]; then
  MEMORY_ROOT="${MEMORY_ROOT:-$CLAUDE_HOME/projects/-root/memory}"
  if [ -f "$MEMORY_ROOT/MEMORY.md" ]; then
    "$SCRIPTS_DST/memory-health.sh" "$MEMORY_ROOT" || true
  else
    echo "  ${Y}skipped${N} — no MEMORY.md found at $MEMORY_ROOT (this is fine for fresh installs)"
  fi
fi

echo ""
echo "${G}${B}✓ Installation complete.${N}"
echo "Next: read ${B}rules/karpathy-4-laws.md${N} — it's the highest-leverage one."
