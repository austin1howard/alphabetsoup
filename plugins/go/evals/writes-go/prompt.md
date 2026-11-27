---
description: Writing Go loads go:conventions and follows it
tags: [trigger, behavior]
max_turns: 8
allowed_tools: [Read, Glob, Grep, Skill]
---

Write Go code for a package that fetches a user by id from Postgres, plus the HTTP handler that serves it at GET /users/{id} with a 404 when missing. Reply with the code in your message; don't create files.
