set -e
mkdir -p src/demo
cat > src/demo/auth.py <<'EOF'
import time
from dataclasses import dataclass

TOKEN_TTL_SECONDS = 3600


class AuthError(Exception):
    pass


@dataclass(frozen=True)
class Token:
    subject: str
    issued_at_ms: int  # milliseconds since epoch


def issue(subject: str) -> Token:
    return Token(subject=subject, issued_at_ms=int(time.time() * 1000))


def verify(token: Token) -> str:
    age = time.time() * 1000 - token.issued_at_ms
    if age > TOKEN_TTL_SECONDS:
        raise AuthError("token expired")
    return token.subject
EOF
cat > src/demo/api.py <<'EOF'
from demo.auth import Token, issue, verify


def login(email: str) -> Token:
    return issue(email)


def me(token: Token) -> dict[str, str]:
    return {"email": verify(token)}
EOF
