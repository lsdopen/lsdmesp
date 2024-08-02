from src.app.settings import VALUES
from src.app.utils.password import generate_password

ldap_user = VALUES["lsdmesp"]["ldap"]["readOnlyUser"]
confluent_services = VALUES["lsdmesp"]["confluent"].values()


def set_password(identity):
    return identity.update({"password": f"{generate_password()}"})


def set_ldap_user_password(ldap_user):
    set_password(ldap_user)


def set_confluent_service_password(service):
    for service in confluent_services:
        set_password(service)


if __name__ == "__main__":
    pass
