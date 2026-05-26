#!/usr/bin/env bash
# dna-doctor.sh — single-command health check across rules + memory + scripts
# Usage: bash scripts/dna-doctor.sh [--installed]
#
#   (no flag)     audit the repo files (use this before opening a PR)
#   --installed   audit your live ~/.claude/ install (use this after install.sh)
#
# Exit codes:
#   0  all checks pass
#   1  one or more checks failed

set -u

MODE="repo"
for arg in "$@"; do
  case "$arg" in
    --installed) MODE="installed" ;;
    -h|--help)
      sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'
      exit 0 ;;
    *) echo "unknown flag: $arg (try --help)" >&2; exit 2 ;;
  esac
done

if [ -t 1 ]; then R=$'\033[31m'; Y=$'\033[33m'; G=$'\033[32m'; C=$'\033[36m'; B=$'\033[1m'; N=$'\033[0m'; else R=; Y=; G=; C=; B=; N=; fi

# Resolve directories
if [ "$MODE" = "repo" ]; then
  REPO="$(cd "$(dirname "$0")/.." && pwd)"
  RULES_DIR="$REPO/rules"
  MEMORY_DIR="$REPO/memory-system"
  SCRIPTS_DIR="$REPO/scripts"
  EXAMPLES_DIR="$REPO/examples"
  ROOT_LABEL="$REPO"
else
  CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
  RULES_DIR="$CLAUDE_HOME/rules"
  MEMORY_DIR="$CLAUDE_HOME/rules"
  SCRIPTS_DIR="$CLAUDE_HOME/scripts"
  EXAMPLES_DIR=""
  ROOT_LABEL="$CLAUDE_HOME"
fi

echo "${C}${B}== DNA DOCTOR @ $ROOT_LABEL  (mode: $MODE) ==${N}"
echo ""

pass=0; warn=0; err=0
check_pass() { echo "${G}[OK]${N}   $1"; pass=$((pass+1)); }
check_warn() { echo "${Y}[WARN]${N} $1"; warn=$((warn+1)); }
check_fail() { echo "${R}[FAIL]${N} $1"; err=$((err+1)); }

# ── 1. Rules directory ─────────────────────────────────────────────
echo "${B}1. Rules${N}"
if [ ! -d "$RULES_DIR" ]; then
  check_fail "rules dir missing: $RULES_DIR"
else
  rule_count=$(find "$RULES_DIR" -maxdepth 1 -name '*.md' 2>/dev/null | wc -l)
  if [ "$rule_count" -eq 0 ]; then
    check_fail "no rule files found in $RULES_DIR"
  else
    check_pass "$rule_count rule file(s) present"
  fi

  # Empty file detection
  empty=$(find "$RULES_DIR" -maxdepth 1 -name '*.md' -size 0 2>/dev/null | wc -l)
  if [ "$empty" -gt 0 ]; then
    check_fail "$empty empty rule file(s)"
  else
    check_pass "no empty rule files"
  fi

  # Chinese character leftover (translation milestone v0.1.3)
  if [ "$MODE" = "repo" ]; then
    cn_files=$(grep -lP '[\x{4e00}-\x{9fff}]' "$RULES_DIR"/*.md 2>/dev/null | wc -l)
    if [ "$cn_files" -gt 0 ]; then
      check_warn "$cn_files rule file(s) contain Chinese characters — v0.1.3 expects English-only rules"
    else
      check_pass "all rule files are English-only"
    fi
  fi
fi
echo ""

# ── 2. Memory system ──────────────────────────────────────────────
echo "${B}2. Memory system${N}"
if [ "$MODE" = "repo" ]; then
  if [ ! -d "$MEMORY_DIR" ]; then
    check_fail "memory-system dir missing"
  else
    mem_count=$(find "$MEMORY_DIR" -maxdepth 1 -name '*.md' 2>/dev/null | wc -l)
    if [ "$mem_count" -gt 0 ]; then
      check_pass "$mem_count memory-system file(s) present"
    else
      check_fail "no memory-system files"
    fi

    if [ -f "$MEMORY_DIR/memory-optimization.md" ]; then
      check_pass "memory-optimization.md present"
      cn_count=$(grep -cP '[\x{4e00}-\x{9fff}]' "$MEMORY_DIR/memory-optimization.md" 2>/dev/null)
      cn_count=${cn_count:-0}
      if [ "$cn_count" -eq 0 ]; then
        check_pass "memory-optimization.md is English-only"
      else
        check_warn "memory-optimization.md has $cn_count line(s) with Chinese"
      fi
    else
      check_fail "memory-optimization.md missing"
    fi
  fi
else
  # In installed mode, defer to memory-health.sh if a real memory store exists
  PROJ_MEM="$HOME/.claude/projects/-root/memory"
  if [ -d "$PROJ_MEM" ] && [ -f "$PROJ_MEM/MEMORY.md" ]; then
    if [ -x "$SCRIPTS_DIR/memory-health.sh" ] || [ -f "$SCRIPTS_DIR/memory-health.sh" ]; then
      check_pass "delegating to memory-health.sh ($PROJ_MEM)"
      bash "$SCRIPTS_DIR/memory-health.sh" "$PROJ_MEM" 2>&1 | sed 's/^/    /'
    else
      check_warn "memory-health.sh not installed in $SCRIPTS_DIR"
    fi
  else
    check_warn "no live memory store at $PROJ_MEM (this is fine on a fresh install)"
  fi
fi
echo ""

# ── 3. Scripts ────────────────────────────────────────────────────
echo "${B}3. Scripts${N}"
if [ ! -d "$SCRIPTS_DIR" ]; then
  check_fail "scripts dir missing: $SCRIPTS_DIR"
else
  sh_count=$(find "$SCRIPTS_DIR" -maxdepth 1 -name '*.sh' 2>/dev/null | wc -l)
  if [ "$sh_count" -gt 0 ]; then
    check_pass "$sh_count script(s) present"
  else
    check_fail "no scripts found"
  fi

  # Shebang check
  bad_shebang=0
  while IFS= read -r f; do
    head -1 "$f" | grep -qE '^#!/usr/bin/env (bash|sh)$' || bad_shebang=$((bad_shebang+1))
  done < <(find "$SCRIPTS_DIR" -maxdepth 1 -name '*.sh' 2>/dev/null)
  if [ "$bad_shebang" -eq 0 ]; then
    check_pass "all scripts have portable shebangs"
  else
    check_warn "$bad_shebang script(s) missing #!/usr/bin/env shebang"
  fi

  # ShellCheck — only if available
  if command -v shellcheck >/dev/null 2>&1; then
    sc_fail=0
    sc_out=""
    while IFS= read -r f; do
      if ! out=$(shellcheck -S warning "$f" 2>&1); then
        sc_fail=$((sc_fail+1))
        sc_out="${sc_out}${out}\n"
      fi
    done < <(find "$SCRIPTS_DIR" -maxdepth 1 -name '*.sh' 2>/dev/null)
    if [ "$sc_fail" -eq 0 ]; then
      check_pass "shellcheck clean (warning+)"
    else
      check_fail "$sc_fail script(s) failed shellcheck"
      printf '%b' "$sc_out" | sed 's/^/    /'
    fi
  else
    check_warn "shellcheck not installed — skipping lint (apt-get install shellcheck)"
  fi
fi
echo ""

# ── 4. Examples (repo mode only) ──────────────────────────────────
if [ "$MODE" = "repo" ] && [ -n "$EXAMPLES_DIR" ]; then
  echo "${B}4. Examples${N}"
  if [ -d "$EXAMPLES_DIR" ]; then
    ex_count=$(find "$EXAMPLES_DIR" -name '*.md' 2>/dev/null | wc -l)
    if [ "$ex_count" -gt 0 ]; then
      check_pass "$ex_count example file(s) present"
    else
      check_warn "no example files"
    fi
  else
    check_warn "examples dir missing"
  fi
  echo ""
fi

# ── 5. Cross-references ──────────────────────────────────────────
if [ "$MODE" = "repo" ]; then
  echo "${B}5. Cross-references${N}"
  REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

  # README must reference key docs
  if [ -f "$REPO_ROOT/README.md" ]; then
    check_pass "README.md present"
    for needle in "install.sh" "rules/" "memory-system/" "CHANGELOG"; do
      if grep -q "$needle" "$REPO_ROOT/README.md"; then
        check_pass "README references $needle"
      else
        check_warn "README does not reference $needle"
      fi
    done
  else
    check_fail "README.md missing"
  fi

  # CHANGELOG
  if [ -f "$REPO_ROOT/CHANGELOG.md" ]; then
    check_pass "CHANGELOG.md present"
  else
    check_warn "CHANGELOG.md missing"
  fi

  # llms.txt
  if [ -f "$REPO_ROOT/llms.txt" ]; then
    check_pass "llms.txt present (AI ingestion discoverability)"
  else
    check_warn "llms.txt missing"
  fi
  echo ""
fi

# ── Summary ───────────────────────────────────────────────────────
total=$((pass + warn + err))
echo "${C}${B}== SUMMARY ==${N}"
echo "Total checks: $total"
echo "${G}PASS${N}: $pass    ${Y}WARN${N}: $warn    ${R}FAIL${N}: $err"

if [ "$err" -gt 0 ]; then
  echo ""
  echo "${R}${B}DNA health: NEEDS ATTENTION${N}"
  exit 1
elif [ "$warn" -gt 0 ]; then
  echo ""
  echo "${Y}${B}DNA health: GREEN with warnings${N}"
  exit 0
else
  echo ""
  echo "${G}${B}DNA health: GREEN${N}"
  exit 0
fi
