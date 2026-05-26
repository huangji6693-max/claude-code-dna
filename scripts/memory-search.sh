#!/usr/bin/env bash
# memory-search.sh — 快速本地记忆检索（BM25 风格打分，无需向量库）
# 用法:
#   memory-search.sh "project-a|project-b|project-c|tools-pack|_global halt"                # 全局搜
#   memory-search.sh -s project-a|project-b|project-c|tools-pack|_global "止损"              # 限定 scope
#   memory-search.sh -t feedback "pua"             # 限定 type
#   memory-search.sh -n 20 "verification"          # top-N

set -u
ROOT="~/.claude/projects/-root/memory"
SCOPE=""
TYPE=""
TOPN=10

while getopts "s:t:n:h" opt; do
  case $opt in
    s) SCOPE="$OPTARG" ;;
    t) TYPE="$OPTARG" ;;
    n) TOPN="$OPTARG" ;;
    h)
      cat <<EOF
memory-search — fast local retrieval for ~/.claude/projects/-root/memory

  -s <scope>   project-a|project-b|project-c|tools-pack|_global|project-a|project-b|project-c|tools-pack|_global|project-a|project-b|project-c|tools-pack|_global|project-a|project-b|project-c|tools-pack|_global|project-a|project-b|project-c|tools-pack|_global  (default: all)
  -t <type>    feedback|project|reference|user|workflow
  -n <N>       top N results (default 10)
  <query>      one or more keywords (AND semantics)
EOF
      exit 0 ;;
  esac
done
shift $((OPTIND-1))

if [ $# -eq 0 ]; then
  echo "usage: memory-search.sh [-s scope] [-t type] [-n N] <query...>" >&2
  exit 2
fi

Q="$*"

# Scope filter
SEARCH_DIR="$ROOT"
if [ -n "$SCOPE" ]; then
  [ -d "$ROOT/$SCOPE" ] && SEARCH_DIR="$ROOT/$SCOPE" || { echo "scope $SCOPE not found" >&2; exit 3; }
fi

# Type filter — file name prefix convention: <type>_<scope>_<topic>.md
NAME_GLOB="*.md"
[ -n "$TYPE" ] && NAME_GLOB="${TYPE}_*.md"

# BM25-ish: count term occurrences, multiply by inverse file length, sum per file.
# For <1000 files this beats vector DB on simplicity, is instant on ripgrep.

declare -A score

# Build per-term matches
for term in $Q; do
  # grep counts per file
  while IFS=: read -r file cnt; do
    [ -z "$file" ] && continue
    # Length penalty: score += cnt / log(lines+10)
    lines=$(wc -l < "$file" 2>/dev/null || echo 100)
    # Use bc for float if available, else integer approximation
    if command -v python3 >/dev/null; then
      inc=$(python3 -c "import math; print(round($cnt / math.log($lines+10), 3))")
    else
      inc=$cnt
    fi
    score["$file"]=$(python3 -c "print(round(${score[$file]:-0} + $inc, 3))")
  done < <(grep -rcIi --include="$NAME_GLOB" "$term" "$SEARCH_DIR" 2>/dev/null | grep -v ':0$')
done

if [ ${#score[@]} -eq 0 ]; then
  echo "(no results for: $Q)"
  exit 0
fi

# Sort descending
{
  for f in "${!score[@]}"; do
    printf '%s\t%s\n' "${score[$f]}" "$f"
  done
} | sort -rn -k1,1 | head -n "$TOPN" | while IFS=$'\t' read -r s f; do
  rel="${f#$ROOT/}"
  # Pull description line from frontmatter
  desc=$(awk '/^description:/{sub(/^description: */,""); print; exit}' "$f" 2>/dev/null)
  printf '%5s  %s\n' "$s" "$rel"
  [ -n "$desc" ] && printf '       └─ %s\n' "$desc"
done
