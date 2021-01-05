import getpass
import subprocess


def main():
    password = getpass.getpass("Enter password to unlock keyring: ")
    subprocess.run(
        ["gnome-keyring-daemon", "--unlock"],
        input=password.encode("utf-8") + b"\n",
        check=True,
    )


if __name__ == "__main__":
    main()
