# Agent Instructions

Personal defaults for AI coding agents (Claude Code, Codex, Cursor, etc.)

## Git

- **Commit after each logical change** - commit immediately after completing a discrete task before starting the next one
- Use conventional commits: `feat:`, `fix:`, `refactor:`, `docs:`, `chore:`, etc.
- Commit messages: concise subject (<50 chars), body when needed
- Never force push or amend without explicit permission
- Prefer small, focused commits over large changesets

## Code Style

- Keep it simple - avoid over-engineering
- Match existing patterns in the codebase
- No unnecessary comments or docstrings
- Use early returns to reduce nesting

## Behavior

- Read before editing - understand context first
- Ask clarifying questions rather than making assumptions
- Prefer editing existing files over creating new ones
