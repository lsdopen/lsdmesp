import click
from src.app.create_tls_artifact import generate_tls_artifacts
from src.app.create_values_yaml import write_yaml
from src.app.settings import VALUES, VALUES_YAML_PATH

CONTEXT_SETTINGS = {"help_option_names": ["-h", "--help"]}


@click.group(context_settings=CONTEXT_SETTINGS)
def cli():
    """LSD MESP Auth Automation"""


@cli.command()
def create_tls_artifacts():
    """
    Creates cert files: [ca-key.pem, ca.pem, mds-tokenkeypair.pem, mds-tokenkeypair.pem]
    """
    generate_tls_artifacts()


@cli.command()
def create_values_yaml():
    """
    Create helm values file.
    """
    write_yaml(VALUES_YAML_PATH, VALUES)


@cli.command()
def create_all_artifacts():
    """
    Creates all authentication artifacts.
    """
    generate_tls_artifacts()
    write_yaml(VALUES_YAML_PATH, VALUES)
