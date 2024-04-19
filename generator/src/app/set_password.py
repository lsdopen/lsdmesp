from src.app.password import generate_password
from src.app.settings import VALUES


def set_password(identity):
    return identity.update({"password": f"{generate_password()}"})


def set_ldap_admin_config_password():
    VALUES["lsdmesp"]["ldap"]["readOnlyUser"]["password"] = f"{generate_password()}"
    VALUES["lsdmesp"]["ldap"]["admin_password"] = f"{generate_password()}"
    VALUES["lsdmesp"]["ldap"]["config_password"] = f"{generate_password()}"


def set_confluent_service_password():
    confluent_services = VALUES["lsdmesp"]["confluent"].values()
    for service in confluent_services:
        set_password(service)


if __name__ == "__main__":
    pass
