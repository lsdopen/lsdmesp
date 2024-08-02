import json

import yaml
from src.app.settings import BASE_DIR, CREDENTIALS_PATH, PROJECT_HOME

values_yaml_file = PROJECT_HOME / "values.yaml"


# Reading values.yaml file
def read_values_yaml(values_yaml_file):
    with open(values_yaml_file, "r") as f:
        data = yaml.load(f, Loader=yaml.FullLoader)
        return data


# Reading users.json file
users_json_file = BASE_DIR / "app" / "data" / "users.json"
with open(users_json_file, "r") as file:
    users_template = json.load(file)


def tls_files():
    data = read_values_yaml(values_yaml_file)
    tls = data["lsdmesp"]["tls"]

    files = {
        "mds-token-private-key.txt": f"{tls['mds']['key']}",
        "mds-token-public-key.txt": f"{tls['mds']['publicKey']}",
        "tls-crt.txt": f"{tls['ca']['cert']}",
        "tls-key.txt": f"{tls['ca']['key']}",
    }
    return files


def update_password(users_template):
    data = read_values_yaml(values_yaml_file)
    user_data = data["lsdmesp"]["confluent"]
    for user in users_template.keys():
        users_template[user].update({"password": f"{user_data[user]['password']}"})


def create_usr_txt_file(data):
    filenames = data.keys()
    for filename in filenames:
        with open(f"{CREDENTIALS_PATH / filename }-login.txt", "w") as file:
            for key, value in data[filename].items():
                file.write(f"{key}={value}\n")


def create_tls_txt_file(tls_data):
    for filename in tls_data.keys():
        with open(f"{CREDENTIALS_PATH / filename}", "w") as file:
            file.write(tls_data[filename])


def create_txt_files(user_template):
    update_password(users_template)
    create_usr_txt_file(users_template)
    create_tls_txt_file(tls_files())


if __name__ == "__main__":
    create_txt_files(users_template)
