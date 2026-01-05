import pytest
import sys
import os

# Put app directory in path so we can import 'app'
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app import app

@pytest.fixture
def client():
    app.config['TESTING'] = True
    with app.test_client() as client:
        yield client

def test_hello(client):
    rv = client.get('/')
    assert rv.status_code == 200
    assert b"Hello World" in rv.data

def test_health(client):
    rv = client.get('/health')
    assert rv.status_code == 200
    assert b"OK" in rv.data

def test_404(client):
    rv = client.get('/non-existent')
    assert rv.status_code == 404
