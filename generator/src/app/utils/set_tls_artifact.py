import pem  # type: ignore
from src.app.settings import CA, CA_KEY, MDS_PUBLIC_KEY, MDS_TOKEN_KEY_PAIR


def read_tls_artifact(path):
    cert = pem.parse_file(path)
    return str(cert[0])


def set_tls_values(values, tls_section):
    values.update(tls_section)


def tls_section():
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
    return TLS_SECTION


if __name__ == "__main__":
    pass
