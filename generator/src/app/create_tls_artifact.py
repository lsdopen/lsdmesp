import subprocess

from src.app.settings import TLS_SCRIPT


def generate_tls_artifacts():
    subprocess.run(TLS_SCRIPT)


if __name__ == "__main__":
    generate_tls_artifacts()
