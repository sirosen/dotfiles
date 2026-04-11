#!/usr/bin/python
# /// script
# dependencies = ['requests', 'packaging']
# ///
import argparse
import datetime as dt
import sys
import typing as t

import packaging.version
import requests
from packaging.utils import parse_sdist_filename, parse_wheel_filename


def main() -> None:
    pkg, prior_to_date = _parse_args()
    version = get_pkg_latest(pkg, prior_to_date)

    print(f"the latest version of '{pkg}' is '{version}'")
    print(f"'{pkg}=={version}'")


def _parse_args() -> tuple[str, dt.datetime | None]:
    parser = argparse.ArgumentParser()
    parser.add_argument("PACKAGE_NAME", help="A python package name, e.g. 'mypy'")
    parser.add_argument("--uploaded-prior-to")
    args = parser.parse_args()

    pkg = args.PACKAGE_NAME
    prior_to_date = None
    if args.uploaded_prior_to:
        prior_to_date = dt.datetime.fromisoformat(args.uploaded_prior_to)
        if prior_to_date.tzinfo is None:
            prior_to_date = prior_to_date.astimezone()

    return pkg, prior_to_date


def get_pkg_latest(name: str, prior_to: dt.datetime | None) -> str:
    pkg_data = requests.get(
        f"https://pypi.python.org/simple/{name}",
        headers={"Accept": "application/vnd.pypi.simple.v1+json"},
    ).json()
    files = pkg_data["files"]
    if prior_to:
        files = _filter_files(files, prior_to)
    return _find_latest(files)


def _filter_files(
    files: list[dict[str, t.Any]], prior_to: dt.datetime
) -> list[dict[str, t.Any]]:
    return [f for f in files if dt.datetime.fromisoformat(f["upload-time"]) < prior_to]


def _find_latest(files: list[dict[str, t.Any]]) -> str:
    # scan all dist filenames and extract the parsed version numbers as a set
    # multiple files easily have the same version, but we can't fully avoid
    # re-parsing them
    versions = {_filename_to_version(f["filename"]) for f in files}
    if not versions:
        print("No matching versions found!", file=sys.stderr)
        sys.exit(1)
    return str(max(versions))


def _filename_to_version(filename: str) -> packaging.version.Version:
    if filename.endswith(".whl"):
        return parse_wheel_filename(filename)[1]
    return parse_sdist_filename(filename)[1]


if __name__ == "__main__":
    main()
