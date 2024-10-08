""" https://www.geeksforgeeks.org/create-a-random-password-generator-using-python/ """

import random
import string

import click

lowercase = list(string.ascii_lowercase)
uppercase = list(string.ascii_uppercase)
digits = list(string.digits)

NUMBER_OF_CHARACTERS = 15

random.shuffle(lowercase)
random.shuffle(uppercase)
random.shuffle(digits)

part_one = round(NUMBER_OF_CHARACTERS * (40 / 100))
part_two = round(NUMBER_OF_CHARACTERS * (20 / 100))


result = []

for x in range(part_one):
    result.append(lowercase[x])
    result.append(uppercase[x])

for x in range(part_two):
    result.append(digits[x])


def generate_password():
    random.shuffle(result)
    return "".join(result)


if __name__ == "__main__":
    click.echo("Password: " + generate_password())
