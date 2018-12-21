

def load_env_file(filename):
    variables = {}
    with open(filename) as f:
        for line in f:
            # Skip comments and empty lines
            if line.startswith("#") or "=" not in line:
                continue

            key, value = line.strip().split("=", 1)
            variables[key] = value

    return variables
