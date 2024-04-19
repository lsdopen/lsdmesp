import pem  # type: ignore
from src.app.settings import CREDENTIALS_PATH, VALUES

CA = CREDENTIALS_PATH / "ca.pem"
CA_KEY = CREDENTIALS_PATH / "ca-key.pem"
MDS_PUBLIC_KEY = CREDENTIALS_PATH / "mds-publickey.pem"
MDS_TOKEN_KEY_PAIR = CREDENTIALS_PATH / "mds-tokenkeypair.pem"


def read_tls_artifact(path):
    cert = pem.parse_file(path)
    return str(cert[0])


TLS_SECTION = {
    "tls": {
        "ca": {
            "cert": f"{read_tls_artifact(CA)}",
            "key": f"{read_tls_artifact(CA_KEY)}",
        },
        "mds": {
            "key": f"{read_tls_artifact(MDS_TOKEN_KEY_PAIR)}",
            "publicKey": f"{read_tls_artifact(MDS_PUBLIC_KEY)}",
        },
    }
}


def set_tls_values():
    VALUES["lsdmesp"].update(TLS_SECTION)


if __name__ == "__main__":
    pass
