import hashlib
from os import getcwd, listdir, walk
from os.path import dirname, expanduser, join, normpath
from pathlib import Path

# First get the root
project_root = "get root via manually entering here or through os or through some other utils"

def get_files():
    current_path = project_root.joinpath('cpp')
    files_to_hash = []

    for root, dirs, files in walk(current_path):
        files_to_hash = [join(root, file) for root, dirs, files in walk(expanduser(current_path)) for file in files]
    return files_to_hash

def generate_hashes():
    files = get_files()
    hashes = []
    for each_file in files:
        # choose hash algorithm here
        hasher = hashlib.sha256()
        with open(each_file, "rb") as f:
            for chunk in iter(lambda: f.read(4096), b""):
                hasher.update(chunk)
        hashes.append('{}\t{}\n'.format(each_file.replace(normpath(project_root),''), hasher.hexdigest()))
    return hashes

def save_hashes():
    hashes = generate_hashes()
    with open('hash-list.txt', 'w') as f:
        for hash in hashes:
            f.write(hash)

if __name__ == '__main__':
    save_hashes()
