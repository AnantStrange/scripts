#! /usr/bin/python3

import os
import shutil
import sys
from datetime import datetime
from tqdm import tqdm

def parse_gitignore(path):
    gitignore_path = os.path.join(path, ".gitignore")
    print(f"gitignore_path : {gitignore_path}")
    excludes = set()
    if os.path.isfile(gitignore_path):
        with open(gitignore_path, "r") as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith("#"):
                    # Resolve relative paths to absolute
                    excludes.add(os.path.abspath(os.path.join(path, line)))
    return excludes

def backup_path(path, dest_dir=None):
    base_name = os.path.basename(os.path.abspath(path))  # Get directory name, not "."
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    
    if os.path.isfile(path):
        name, ext = os.path.splitext(base_name)
        backup_name = f"{name}_{timestamp}.bak{ext}"
    elif os.path.isdir(path):
        backup_name = f"{base_name}_{timestamp}.bak"
    else:
        raise FileNotFoundError(f"{path} does not exist.")
    
    if dest_dir:
        os.makedirs(dest_dir, exist_ok=True)
        return os.path.join(dest_dir, backup_name)
    else:
        return backup_name


def copy_with_progress(src, dest):
    total_size = os.path.getsize(src)
    
    with tqdm(total=total_size, unit='B', unit_scale=True, desc=f"Copying {src}") as pbar:
        with open(src, 'rb') as fsrc, open(dest, 'wb') as fdst:
            while True:
                buf = fsrc.read(1024*1024)  # 1 MB buffer size
                if not buf:
                    break
                fdst.write(buf)
                pbar.update(len(buf))
    return

def copy_dir_with_progress(src_dir, dest_dir, excludes=set()):
    total_size = 0
    
    # Calculate total size of non-ignored files
    for root, dirs, files in os.walk(src_dir):
        # Filter out ignored directories
        dirs[:] = [
            d for d in dirs if os.path.abspath(os.path.join(root, d)) not in excludes
        ]
        for file_ in files:
            src_path = os.path.join(root, file_)
            if os.path.abspath(src_path) not in excludes:
                total_size += os.path.getsize(src_path)

    # Show progress bar only if total size is greater than 100MB
    show_progress = total_size > 100 * 1024 * 1024  # 100MB
    
    if show_progress:
        with tqdm(total=total_size, unit='B', unit_scale=True, desc=f"Copying directory {src_dir}") as pbar:
            for root, dirs, files in os.walk(src_dir):
                dirs[:] = [
                    d for d in dirs if os.path.abspath(os.path.join(root, d)) not in excludes
                ]
                for file_ in files:
                    src_path = os.path.join(root, file_)
                    if os.path.abspath(src_path) not in excludes:
                        dst_path = src_path.replace(src_dir, dest_dir, 1)
                        os.makedirs(os.path.dirname(dst_path), exist_ok=True)
                        shutil.copy2(src_path, dst_path)
                        pbar.update(os.path.getsize(src_path))
    else:
        # If no progress bar, just copy the files without showing progress
        for root, dirs, files in os.walk(src_dir):
            dirs[:] = [
                d for d in dirs if os.path.abspath(os.path.join(root, d)) not in excludes
            ]
            for file_ in files:
                src_path = os.path.join(root, file_)
                if os.path.abspath(src_path) not in excludes:
                    dst_path = src_path.replace(src_dir, dest_dir, 1)
                    os.makedirs(os.path.dirname(dst_path), exist_ok=True)
                    shutil.copy2(src_path, dst_path)




def backup(path, dest_dir=None, gitignore=False, excludes=None):
    excludes = excludes or set()
    if gitignore and os.path.isdir(path):
        excludes.update(parse_gitignore(path))
    
    backup_file_path = backup_path(path, dest_dir)
    
    if os.path.isfile(path):
        if path in excludes:
            print(f"Skipping excluded file: {path}")
            return
        copy_with_progress(path, backup_file_path)
        print(f"File backed up to {backup_file_path}")
    elif os.path.isdir(path):
        copy_dir_with_progress(path, backup_file_path, excludes)
        print(f"Directory backed up to {backup_file_path}")
    else:
        raise FileNotFoundError(f"{path} does not exist.")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python backup.py <file_or_directory> [-d destination_directory] [-gi | --gitignore] [-ex | --exclude path1,path2,...]")
        sys.exit(1)
    
    path = sys.argv[1]
    dest_dir = None
    gitignore = False
    excludes = set()
    
    if "-d" in sys.argv:
        dest_dir_index = sys.argv.index("-d") + 1
        if dest_dir_index < len(sys.argv):
            dest_dir = sys.argv[dest_dir_index]
    
    if "-gi" in sys.argv or "--gitignore" in sys.argv:
        gitignore = True
    
    if "-ex" in sys.argv or "--exclude" in sys.argv:
        exclude_index = sys.argv.index("-ex") if "-ex" in sys.argv else sys.argv.index("--exclude")
        exclude_index += 1
        if exclude_index < len(sys.argv):
            excludes.update(os.path.abspath(p) for p in sys.argv[exclude_index].split(","))
    
    try:
        backup(path, dest_dir, gitignore, excludes)
    except Exception as e:
        print(f"Error: {e}")

