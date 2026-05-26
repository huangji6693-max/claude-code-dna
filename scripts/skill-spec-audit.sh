#!/usr/bin/env bash
# skill-spec-audit.sh — audit skill compliance against the agentskills.io spec
# Source: anthropics/skills/spec/agent-skills-spec.md
# Usage: bash ~/.claude/scripts/skill-spec-audit.sh [skills-root]
#        Defaults to auditing ~/.claude/skills/

set -u
ROOT="${1:-~/.claude/skills}"

if [ ! -d "$ROOT" ]; then
  echo "ERR: $ROOT not found" >&2
  exit 2
fi

if [ -t 1 ]; then R=$'\033[31m'; Y=$'\033[33m'; G=$'\033[32m'; C=$'\033[36m'; B=$'\033[1m'; N=$'\033[0m'; else R=; Y=; G=; C=; B=; N=; fi

total=0; pass=0; warn=0; err=0
declare -a fail_list=() warn_list=()

echo "${C}${B}== SKILL SPEC AUDIT @ $ROOT ==${N}"
echo "${C}Spec: agentskills.io · name ≤64/[a-z0-9-]+/=dirname · desc ≤1024 · SKILL.md ≤500 lines${N}"
echo ""

for dir in "$ROOT"/*/; do
  [ -d "$dir" ] || continue
  total=$((total+1))
  skill_name=$(basename "$dir")
  skill_md="$dir/SKILL.md"
  issues=()
  has_err=0

  # 1) SKILL.md must exist
  if [ ! -f "$skill_md" ]; then
    issues+=("missing SKILL.md")
    has_err=1
    fail_list+=("${R}[FAIL]${N} $skill_name :: ${issues[*]}")
    err=$((err+1))
    continue
  fi

  # 2) Frontmatter delimiters
  first=$(head -1 "$skill_md")
  if [ "$first" != "---" ]; then
    issues+=("frontmatter missing opening ---"); has_err=1
  fi
  fm_close_line=$(awk '/^---$/{n++; if (n==2) {print NR; exit}}' "$skill_md")
  if [ -z "$fm_close_line" ]; then
    issues+=("frontmatter missing closing ---"); has_err=1
  fi

  # 3) name field
  name_val=$(awk -F': *' '/^name: *.+/ && !found {print $2; found=1}' "$skill_md" | sed 's/[[:space:]]*$//')
  if [ -z "$name_val" ]; then
    issues+=("name field missing"); has_err=1
  else
    if [ ${#name_val} -gt 64 ]; then
      issues+=("name too long (${#name_val}>64)"); has_err=1
    fi
    if ! [[ "$name_val" =~ ^[a-z0-9-]+$ ]]; then
      issues+=("name invalid chars: '$name_val'"); has_err=1
    fi
    if [[ "$name_val" =~ ^- ]] || [[ "$name_val" =~ -$ ]]; then
      issues+=("name starts/ends with -"); has_err=1
    fi
    if [[ "$name_val" =~ -- ]]; then
      issues+=("name has -- consecutive"); has_err=1
    fi
    if [ "$name_val" != "$skill_name" ]; then
      issues+=("name '$name_val' != dir '$skill_name'"); has_err=1
    fi
  fi

  # 4) description field (parsed only inside frontmatter; handles single-line and YAML |/> block forms)
  desc_val=$(awk '
    NR == 1 && /^---$/ { in_fm = 1; next }
    in_fm && /^---$/ { in_fm = 0; exit }
    !in_fm { next }
    /^description:/ {
      capture = 1
      line = $0
      sub(/^description: */, "", line)
      sub(/^[|>][+-]?[[:space:]]*$/, "", line)
      if (length(line) > 0) buf = line
      next
    }
    capture && /^[a-zA-Z][a-zA-Z0-9_-]*: */ { capture = 0; next }
    capture {
      line = $0
      sub(/^[[:space:]]+/, "", line)
      if (length(line) > 0) buf = (buf == "" ? line : buf " " line)
    }
    END { print buf }
  ' "$skill_md")
  if [ -z "$desc_val" ]; then
    issues+=("description missing"); has_err=1
  elif [ ${#desc_val} -gt 1024 ]; then
    issues+=("description ${#desc_val}>1024"); has_err=1
  fi

  # 5) SKILL.md line count
  lines=$(wc -l < "$skill_md")
  if [ "$lines" -gt 500 ]; then
    issues+=("$lines lines >500 (split to references/)")
    # Over-cap is a WARN (the spec recommends, doesn't strictly require, the 500-line cap)
  fi

  # Classify
  if [ ${#issues[@]} -eq 0 ]; then
    pass=$((pass+1))
  elif [ "$has_err" -eq 1 ]; then
    err=$((err+1))
    fail_list+=("${R}[FAIL]${N} $skill_name :: ${issues[*]}")
  else
    warn=$((warn+1))
    warn_list+=("${Y}[WARN]${N} $skill_name :: ${issues[*]}")
  fi
done

[ ${#fail_list[@]} -gt 0 ] && printf '%s\n' "${fail_list[@]}"
[ ${#warn_list[@]} -gt 0 ] && printf '%s\n' "${warn_list[@]}"
true

echo ""
echo "${C}${B}=== SUMMARY ===${N}"
echo "Total skills: $total"
echo "${G}PASS${N}: $pass    ${Y}WARN${N}: $warn    ${R}FAIL${N}: $err"
echo ""
echo "Spec: github.com/anthropics/skills/blob/main/spec/agent-skills-spec.md"

[ "$err" -gt 0 ] && exit 1 || exit 0
