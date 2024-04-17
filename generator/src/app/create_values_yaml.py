from generator.src.app.formatter import yaml
from generator.src.app.set_password import (
    confluent_services,
    ldap_user,
    set_confluent_service_password,
    set_ldap_user_password,
)
from generator.src.app.set_tls_artifact import TLS_SECTION, set_tls_values
from generator.src.app.settings import VALUES, VALUES_YAML_PATH


def write_yaml(path, data):
    set_ldap_user_password(ldap_user)
    set_confluent_service_password(confluent_services)
    set_tls_values(VALUES["lsdmesp"], TLS_SECTION)
    with open(path, "w") as file:
        yaml.dump(data, file, sort_keys=False)


if __name__ == "__main__":
    write_yaml(VALUES_YAML_PATH, VALUES)
