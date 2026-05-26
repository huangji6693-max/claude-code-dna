# Security Policy

## Scope

This repository ships **markdown rules**, **bash + python3 scripts**, and a
**CSV catalog**. It does not run as a service, does not network out, and does
not handle credentials.

The realistic threat surface is therefore narrow:

1. A malicious PR sneaks a backdoor into `install.sh` or one of the
   `scripts/*.sh` files (these run on a user's machine when invoked).
2. A malicious PR seeds a prompt-injection payload inside a rule file
   (`rules/*.md`), which then influences the user's agent at SessionStart.
3. A misclassified entry in `catalog/*.csv` points a user at a malicious
   upstream skill/agent repository.

## Supported versions

Only the latest tagged release receives security fixes.

| Version | Supported |
|---------|-----------|
| 0.1.x   | ✅        |
| < 0.1   | ❌        |

## Reporting a vulnerability

**Please do not file public issues for security reports.**

Use GitHub's [private vulnerability reporting](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability)
on this repository:

1. Go to the **Security** tab → **Report a vulnerability**
2. Describe the impact, reproduction steps, and any suggested patch
3. Expect an initial acknowledgement within 7 days

For non-vulnerability concerns (e.g., a catalog entry points at a suspicious
upstream), open a regular issue with the `security` label.

## What we will do

- Triage within 7 days
- Patch + advisory + new tagged release within 30 days for confirmed issues
- Credit reporters in the advisory unless they prefer anonymity

## What we will not do

- Pay bounties (this is an unfunded open-source project)
- Backport fixes to releases older than the current minor version
