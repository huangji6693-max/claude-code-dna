#!/usr/bin/env bash
# memory-health.sh — global memory-system health audit
# Usage: bash ~/.claude/scripts/memory-health.sh [project-root]
# Defaults to auditing ~/.claude/projects/-root/memory

set -u
ROOT="${1:-~/.claude/projects/-root/memory}"
INDEX="$ROOT/MEMORY.md"

if [ ! -f "$INDEX" ]; then
  echo "ERR: $INDEX not found" >&2
  exit 2
fi

# ANSI (optional)
if [ -t 1 ]; then R=$'\033[31m'; Y=$'\033[33m'; G=$'\033[32m'; C=$'\033[36m'; N=$'\033[0m'; else R=; Y=; G=; C=; N=; fi

warn=0; err=0

echo "${C}== MEMORY HEALTH @ $ROOT ==${N}"

# 1) MEMORY.md size (hard cap 200 per memory-optimization.md)
lines=$(wc -l < "$INDEX")
if [ "$lines" -gt 200 ]; then
  echo "${R}[ERR]${N} MEMORY.md = ${lines} lines (cap 200) — must collapse into sub-INDEX files"
  err=$((err+1))
elif [ "$lines" -gt 150 ]; then
  echo "${Y}[WARN]${N} MEMORY.md = ${lines} lines (approaching 200)"
  warn=$((warn+1))
else
  echo "${G}[OK]${N} MEMORY.md = ${lines} lines"
fi

# 2) File count (Karpathy: <1000 stays markdown-only)
total=$(find "$ROOT" -name '*.md' -not -path '*/archive/*' | wc -l)
if [ "$total" -ge 1000 ]; then
  echo "${Y}[WARN]${N} ${total} memory files — consider introducing vector retrieval"
  warn=$((warn+1))
else
  echo "${G}[OK]${N} ${total} memory files (markdown-only threshold 1000)"
fi

# 3) Broken links in MEMORY.md — flag targets that don't exist
broken=0
while IFS= read -r link; do
  [ -z "$link" ] && continue
  # Resolve relative to MEMORY.md dir (skip external ../../../ refs)
  case "$link" in
    ../*|http*) continue ;;
  esac
  # Strip strikethrough markers ~~[x](y)~~ → just y
  tgt="$ROOT/$link"
  if [ ! -e "$tgt" ]; then
    echo "${R}[ERR]${N} broken link in MEMORY.md → $link"
    broken=$((broken+1))
  fi
done < <(grep -oE '\]\(([^)]+\.md)\)' "$INDEX" | sed 's/^](//;s/)$//')
[ "$broken" -eq 0 ] && echo "${G}[OK]${N} all MEMORY.md links resolve" || err=$((err+broken))

# 4) Orphan files — memory files not referenced by MEMORY.md or any *_INDEX.md
orphan=0
mapfile -t all_indices < <(find "$ROOT" -maxdepth 3 \( -name 'MEMORY.md' -o -name '_INDEX.md' \) -print)
while IFS= read -r f; do
  rel="${f#"$ROOT"/}"
  base=$(basename "$f")
  # Skip indices themselves
  case "$base" in MEMORY.md|_INDEX.md) continue ;; esac
  # Referenced anywhere?
  if ! grep -l -F "$base" "${all_indices[@]}" >/dev/null 2>&1; then
    echo "${Y}[WARN]${N} orphan (not in any index): $rel"
    orphan=$((orphan+1))
  fi
done < <(find "$ROOT" -name '*.md' -not -name 'MEMORY.md' -not -name '_INDEX.md')
[ "$orphan" -eq 0 ] && echo "${G}[OK]${N} no orphan files" || warn=$((warn+orphan))

# 5) Stale detection (no content change in 90+ days)
stale=$(find "$ROOT" -name '*.md' -mtime +90 | wc -l)
if [ "$stale" -gt 0 ]; then
  echo "${Y}[WARN]${N} ${stale} files untouched >90d — review expires_when"
  warn=$((warn+1))
else
  echo "${G}[OK]${N} no files >90d stale"
fi

# 6) Strikethrough count — should be cleaned monthly
strike=$(grep -c '^- ~~' "$INDEX" || true)
if [ "$strike" -gt 5 ]; then
  echo "${Y}[WARN]${N} ${strike} strikethrough entries in MEMORY.md — clean up monthly"
  warn=$((warn+1))
else
  echo "${G}[OK]${N} ${strike} strikethrough entries"
fi

# 7) Missing frontmatter check
no_fm=0
while IFS= read -r f; do
  base=$(basename "$f")
  case "$base" in MEMORY.md|_INDEX.md|README.md) continue ;; esac
  head -1 "$f" | grep -q '^---$' || no_fm=$((no_fm+1))
done < <(find "$ROOT" -name '*.md')
if [ "$no_fm" -gt 0 ]; then
  echo "${Y}[WARN]${N} ${no_fm} files missing frontmatter"
  warn=$((warn+no_fm))
else
  echo "${G}[OK]${N} all files have frontmatter"
fi

echo
echo "${C}== SUMMARY: ${err} err / ${warn} warn ==${N}"
exit $(( err > 0 ? 1 : 0 ))
