set -e
mkdir -p src/demo tests
touch src/demo/__init__.py
cat > src/demo/pricing.py <<'EOF'
BULK_THRESHOLD = 10
BULK_DISCOUNT = 0.1


def order_total(unit_price: float, quantity: int) -> float:
    total = unit_price * quantity
    if quantity > BULK_THRESHOLD:
        total *= 1 - BULK_DISCOUNT
    return round(total, 2)
EOF
cat > tests/test_pricing.py <<'EOF'
from demo.pricing import order_total


def test_small_order_pays_full_price() -> None:
    assert order_total(5.0, 2) == 10.0


def test_large_order_gets_bulk_discount() -> None:
    assert order_total(10.0, 20) == 180.0
EOF
printf '[project]\nname = "demo"\nversion = "0.1.0"\n' > pyproject.toml
