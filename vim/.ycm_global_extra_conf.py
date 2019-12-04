import os

HOME = os.getenv("HOME")
CLASSIC_VENV_NAMES = [".venv", "venv"]


def _find_common_venv_interpreter(dirname):
    for name in CLASSIC_VENV_NAMES:
        interpreter_path = os.path.join(name, "bin", "python")
        if os.path.exists(interpreter_path):
            return interpreter_path
    dir_to_check = os.path.dirname(dirname)
    if HOME.startswith(dir_to_check):
        return None
    elif dir_to_check == "/":
        return None
    else:
        return _find_common_venv_interpreter(dir_to_check)


def Settings(**kwargs):
    interpreter_path = _find_common_venv_interpreter(os.getcwd())
    if interpreter_path:
        return {"interpreter_path": interpreter_path}
    else:
        return {}
