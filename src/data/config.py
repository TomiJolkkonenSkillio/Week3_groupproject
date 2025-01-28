import os
from configparser import ConfigParser

def config(filename='database.ini', section='postgresql'):
    # Resolve the absolute path
    base_dir = os.path.dirname(os.path.abspath(__file__))  # Directory of config.py
    file_path = os.path.join(base_dir, filename)
    print(file_path)
    
    parser = ConfigParser()
    parser.read(file_path)
    db = {}

    if parser.has_section(section):
        params = parser.items(section)
        for param in params:
            db[param[0]] = param[1]
    else:
        raise Exception('Section {0} not found in the {1} file'.format(section, file_path))

    return db

if __name__ == '__main__':
    config()
