"""Configuration for LSD MESP CLI tool."""

from setuptools import find_packages, setup

setup(
    name="mesp",
    version="0.0.1",
    packages=find_packages(),
    include_package_data=True,
    package_data={"src": ["app/values.json", "app/scripts/*.sh"]},
    install_requires=[
        "click",
        "pem",
        "pyyaml",
    ],
    entry_points="""
    [console_scripts]
    mesp=src.cli:cli
    """,
)
