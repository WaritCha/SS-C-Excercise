import requests
import sys
import os

def test_app_health():
    # Get URL from environment variable or default to localhost
    url = os.environ.get("APP_URL", "http://localhost:8080")
    print(f"Testing health of {url}...")

    try:
        response = requests.get(f"{url}/health")
        if response.status_code == 200:
            print("Health Check Passed!")
            sys.exit(0)
        else:
            print(f"Health Check Failed! Status Code: {response.status_code}")
            sys.exit(1)
    except requests.exceptions.RequestException as e:
        print(f"Connection failed: {e}")
        sys.exit(1)

if __name__ == "__main__":
    test_app_health()
