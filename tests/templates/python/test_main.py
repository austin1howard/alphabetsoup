from httpx import ASGITransport, AsyncClient

from demo.main import app


async def test_healthz_returns_ok() -> None:
    async with AsyncClient(transport=ASGITransport(app=app), base_url="http://test") as client:
        resp = await client.get("/healthz")
    assert resp.status_code == 200
    assert resp.json() == {"status": "ok"}
