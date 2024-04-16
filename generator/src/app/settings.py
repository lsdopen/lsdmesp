import json
import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

PROJECT_HOME = Path(os.environ.get("PROJECT_HOME"))

CREDENTIALS_PATH = PROJECT_HOME / "assets" / "credentials"

CA = CREDENTIALS_PATH / "ca.pem"

CA_KEY = CREDENTIALS_PATH / "ca-key.pem"

MDS_PUBLIC_KEY = CREDENTIALS_PATH / "mds-publickey.pem"

MDS_TOKEN_KEY_PAIR = CREDENTIALS_PATH / "mds-tokenkeypair.pem"

VALUES_YAML_PATH = PROJECT_HOME / "values.yaml"

TLS_SCRIPT = BASE_DIR / "app" / "scripts" / "tls_artifact.sh"

VALUES_JSON = BASE_DIR / "app" / "values.json"
with open(VALUES_JSON, "r") as file:
    VALUES = json.load(file)

if __name__ == "__main__":
    pass
