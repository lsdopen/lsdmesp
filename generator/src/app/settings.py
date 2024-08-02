import json
import os
from pathlib import Path

import click

BASE_DIR = Path(__file__).resolve().parent.parent

if os.environ.get("PROJECT_HOME"):
    PROJECT_HOME = Path(os.environ.get("PROJECT_HOME"))
    CREDENTIALS_PATH = PROJECT_HOME / "assets" / "credentials"
    VALUES_YAML_PATH = PROJECT_HOME / "values.yaml"
else:
    click.echo("Please set the PROJECT_HOME directory: export PROJECT_HOME=$PWD")

CA = CREDENTIALS_PATH / "ca.pem"
CA_KEY = CREDENTIALS_PATH / "ca-key.pem"
MDS_PUBLIC_KEY = CREDENTIALS_PATH / "mds-publickey.pem"
MDS_TOKEN_KEY_PAIR = CREDENTIALS_PATH / "mds-tokenkeypair.pem"

TLS_SCRIPT = BASE_DIR / "app" / "scripts" / "tls_artifact.sh"

VALUES_JSON = BASE_DIR / "app" / "data" / "values.json"
with open(VALUES_JSON, "r") as file:
    VALUES = json.load(file)


if __name__ == "__main__":
    pass
