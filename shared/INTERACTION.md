# Interaction Protocol

Every agent ends each turn with this structure. Copy the template below — do not omit the Summary; omit the Requests section entirely when there is nothing to hand off.

```
## Summary
- What was completed this turn (always present). Refs: specs/…, files changed…

## Requests (only if needed — omit this section entirely when nothing is needed)
- @<agent|user>: explicit request / action item
- @<agent|user>: … (one or more; may address multiple recipients)
```

**Rules:**
- **Summary** is always required. Be specific: list files changed, specs referenced, decisions made.
- **Requests** is optional. Include it only when you need something from another agent or the user.
- Address requests to `@aspen`, the appropriate engineer agent by name, or `@user`.
- One concrete action item per bullet. No vague asks.
- Do not fabricate a Requests section just to fill the template.
