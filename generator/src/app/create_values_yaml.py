from src.app.formatter import yaml
from src.app.set_password import (
    set_confluent_service_password,
    set_ldap_admin_config_password,
)
from src.app.set_tls_artifact import set_tls_values
from src.app.settings import VALUES, VALUES_YAML_PATH


def write_yaml(path, data):
    set_ldap_admin_config_password()
    set_confluent_service_password()
    set_tls_values()
    with open(path, "w") as file:
        yaml.dump(data, file, sort_keys=False)


if __name__ == "__main__":
    write_yaml(VALUES_YAML_PATH, VALUES)
