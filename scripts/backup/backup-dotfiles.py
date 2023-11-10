""" backup-dotfiles.py
desc:       check selected files for changes and copy them to another folder
usage:      python backup-dotfiles.py
"""

import os
import yaml
import shutil
import filecmp

DESTINATION_DIR = "/home/mishi/Documents/github_repos/dotfiles"
CONFIG_FILE_LOC = "/home/mishi/.config/scripts/backup/backup-dotfiles.yaml"

def create_directories(destination_paths):
    for path in destination_paths:
        directory = os.path.dirname(path)
        if not os.path.exists(directory):
            os.makedirs(directory)

def copy_if_different(source, relative_destination):
    destination = os.path.join(DESTINATION_DIR, relative_destination)
    destination_dir = os.path.dirname(destination)

    # Create any needed subdirectories if they don't exist
    os.makedirs(destination_dir, exist_ok=True)

    if not os.path.exists(destination) or not filecmp.cmp(source, destination):
        shutil.copy2(source, destination)
        print(f"Copied: {source} to {destination}")

def expand_user(path):
    return os.path.expanduser(path)

def list_files_to_backup(paths):
    files_to_backup = []
    for source, relative_destination in paths:
        source = expand_user(source)
        destination = os.path.join(DESTINATION_DIR, relative_destination)

        if os.path.isdir(source):
            # If source is a directory, copy all files within it
            for root, _, files in os.walk(source):
                if "__pycache__" in root:
                    continue  # Skip directories named "__pycache__"
                for file in files:
                    src_file = os.path.join(root, file)
                    dest_file = os.path.join(destination, os.path.relpath(src_file, source))
                    if not os.path.exists(dest_file) or not filecmp.cmp(src_file, dest_file):
                        files_to_backup.append((src_file, dest_file))
        elif not os.path.exists(destination) or not filecmp.cmp(source, destination):
            files_to_backup.append((source, destination))

    return files_to_backup

def main():
    # Load your YAML configuration
    with open(CONFIG_FILE_LOC, 'r') as file:
        config = yaml.safe_load(file)

    # Extract the source and relative destination paths from the configuration, expanding the tilde
    paths = [(item['source'], item['destination']) for item in config['backup-dotfiles']]

    # Create the directories if they don't exist
    create_directories([os.path.join(DESTINATION_DIR, destination) for _, destination in paths])

    # List files that need to be backed up
    files_to_backup = list_files_to_backup(paths)

    if not files_to_backup:
        print("No changes to back up.")
    else:
        print("Files to back up:")
        for source, destination in files_to_backup:
            print(f"Source: {source}\nDestination: {destination}\n")

        user_input = input("Do you want to backup these files? (y/n): ")
        if user_input.lower() == 'y':
            # Copy the files if the user agrees
            for source, relative_destination in files_to_backup:
                copy_if_different(source, relative_destination)

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"error! {e}")
