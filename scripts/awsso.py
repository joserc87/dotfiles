from os import path

CREDENTIALS_PATH = path.join(
    # path.expanduser('~'),
    '/home/jose',
    '.aws/credentials'
)

profile_mapping = {
    '958466354486': 'data_valuation-dev',
    '562161736591': 'data-marketplace-dev',
    '941754979676': 'bigdata-dev',
    '016629673571': 'bigdata-stg',
    '319536452804': 'bigdata-demo',
    '221539845528': 'bigdata-gpbullhound',
    '163889103523': 'bigdata-covalis',
    '159931895472': 'data-marketplace-stg',
}


def paste(arg=None):
    if arg is None:
        try:
            import pyperclip
            return pyperclip.paste()
        except ModuleNotFoundError:
            pass
    return arg


def modify_profile_data(data, new_values):
    output_data = [
        '{} = {}\n'.format(key, value)
        for key, value in new_values.items()
    ]
    for line in data:
        # Remove the old values
        stripped = line.strip()
        if len(stripped) == 0 or stripped[0] in ['#', '[']:
            output_data += [line]

    return output_data


def find_profile_lines(data, profile_name):
    """
    Takes data as a list of lines and finds the range (startline, endline)
    where we found the profile, where startline is the line right after the
    profile name
    """
    start, end = None, None
    for i, line in enumerate(data):
        if start is not None:
            if line[0] == '[':
                end = i
                break
        elif line.startswith('[{}]'.format(profile_name)):
            start = i + 1

    if end is None and start is not None:
        end = len(data)

    return start, end


def modify_credentials(data, profile_name, new_values):
    """
    Takes data as a list of lines and modify the lines corresponding to the
    specified profile
    """
    start, end = find_profile_lines(data, profile_name)

    if start is not None and end is not None:
        profile_data = data[start:end]
        modified_profile = modify_profile_data(profile_data, new_values)
        data = data[:start] + modified_profile + data[end:]

    return data


def copy_profile_lines(data, name_from, name_to):
    """
    Takes data as a list of lines and returns the line after the given profile
    """
    start, end = find_profile_lines(data, name_from)
    _, new_values = parse_values_in_lines(data[start:end])
    return modify_credentials(data, name_to, new_values)


def list_profiles_in_lines(data):
    lines = (line.strip() for line in data)
    return [
        line[1:-1]
        for line in lines
        if line and line[0] == '[' and line[-1] == ']'
    ]


def copy_profile(name_from, name_to='default'):
    """
    Takes data as a list of lines and returns the line after the given profile
    """
    try:
        lines = read_credentials(CREDENTIALS_PATH)
        data = ''.join(copy_profile_lines(
            lines, name_from, name_to))
        write_credentials(CREDENTIALS_PATH, data)
    except Exception as e:
        print(e)
        return False

    return True


def list_profiles():
    try:
        lines = read_credentials(CREDENTIALS_PATH)
        return list_profiles_in_lines(lines)
    except Exception as e:
        print(e)
        return None

    return []


def read_credentials(path):
    with open(path) as f:
        lines = [line for line in f]
        return lines
    return []


def write_credentials(path, data):
    with open(path, 'w') as f:
        f.write(data)


def parse_values_in_lines(lines):
    """
    Parses the lines for 'A = B' lines and returns a dictionary, as well as the
    profile name
    """
    values = {}
    profile_name = None
    for line in lines:
        line = line.strip()
        if len(line) > 2 and line[0] == '[':
            profile_name = line[1:-1]
        try:
            key, val = line.split(' = ')
            values[key] = val
        except Exception:
            pass
    return profile_name, values


def get_new_values():
    credentials = paste()
    if not credentials:
        return None
    lines = credentials.split('\n')
    return parse_values_in_lines(lines)


def update_credentials():
    try:
        lines = read_credentials(CREDENTIALS_PATH)
        sso_profile_name, new_values = get_new_values()
        assert sso_profile_name is not None
        profile_name = profile_mapping.get(sso_profile_name.split('_')[0])
        assert profile_name and new_values and lines

        data = ''.join(modify_credentials(lines, profile_name, new_values))
        write_credentials(CREDENTIALS_PATH, data)
        return profile_name
    except Exception as e:
        print(e)
        return False

    return True


def main():
    update_credentials()


if __name__ == '__main__':
    main()
