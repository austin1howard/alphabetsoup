set -e
mkdir -p specs/features specs/decisions
cat > specs/README.md <<'EOF'
# demo

Account service for the demo app: sign-up, login, sessions.

## Index

| Spec | Covers |
|---|---|
| [architecture](architecture.md) | components, data flow, deployment |
| [domain](domain.md) | entities, invariants, glossary |
| [features/login](features/login.md) | email + password login |
EOF
cat > specs/architecture.md <<'EOF'
# Architecture

| Component | Responsibility | Talks to |
|---|---|---|
| api | HTTP JSON API | db, mailer |
| db | Postgres | — |
| mailer | transactional email (SES) | — |
EOF
cat > specs/domain.md <<'EOF'
# Domain

| Entity | Fields | Invariants |
|---|---|---|
| User | id, email, password_hash | email unique, lowercase |
EOF
cat > specs/features/login.md <<'EOF'
# Login

## Purpose
Users sign in with email + password.

## Behavior
Wrong password or unknown email → same 401 (no account enumeration).

## Contracts
`POST /login {email, password}` → `200 {token}` | `401 {error: "invalid_credentials"}`

## Acceptance criteria
- [ ] Valid credentials return a session token
- [ ] Unknown email and wrong password are indistinguishable
EOF
printf '# demo\n\n## Golden rules\n\n- `specs/` is canonical (what + why). New feature or behavior/contract change → write or update its spec in `specs/` first (`alphabetsoup:specs`), in the same change as the code.\n' > CLAUDE.md
