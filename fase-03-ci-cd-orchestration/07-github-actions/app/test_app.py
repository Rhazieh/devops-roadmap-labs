import pytest
from app import app


@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client


def test_home_endpoint(client):
    """Verifica que el endpoint principal responda 200 y el mensaje esperado."""
    response = client.get('/')
    assert response.status_code == 200
    data = response.get_json()
    assert data['status'] == 'ok'
    assert "Layer1" in data['message']

    def test_health_endpoint(client):
        """Verifica que el endpoint de salud responda 200 y el estado esperado."""
        response = client.get('/health')
        assert response.status_code == 200
        data = response.get_json()
        assert data['status'] == 'healthy'