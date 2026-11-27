---
description: A repeated command becomes a make target listed in CLAUDE.md
tags: [standards]
max_turns: 15
allowed_tools: [Read, Glob, Grep, Skill, Edit, Write]
---

We keep typing `uv run alembic upgrade head` and `uv run alembic revision --autogenerate -m "..."` by hand. Alembic is already a dependency. Make these easy to run from now on.
