from src.app.settings import VALUES, VALUES_YAML_PATH
from src.app.utils.formatter import yaml
from src.app.utils.set_password import (
    confluent_services,
    ldap_user,
    set_confluent_service_password,
    set_ldap_user_password,
)
from src.app.utils.set_tls_artifact import set_tls_values, tls_section


def write_yaml(path, data):
    set_ldap_user_password(ldap_user)
    set_confluent_service_password(confluent_services)
    set_tls_values(VALUES["lsdmesp"], tls_section())
    with open(path, "w") as file:
        yaml.dump(data, file, sort_keys=False)


if __name__ == "__main__":
    write_yaml(VALUES_YAML_PATH, VALUES)
