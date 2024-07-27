#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 <directory>"
    exit 1
}

# Check if exactly one argument is provided
if [ "$#" -ne 1 ]; then
    usage
fi

# Directory where .gitignore will be created
TARGET_DIR="$1"

# Array of file types to ignore (hardcoded)
FILETYPES=()

# Check if the directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory '$TARGET_DIR' does not exist."
    exit 1
fi

# Create or overwrite the .gitignore file in the specified directory
GITIGNORE_FILE="$TARGET_DIR/.gitignore"

# Start writing to the .gitignore file
echo "# Automatically generated .gitignore" > "$GITIGNORE_FILE"

# Add common entries to the .gitignore file
cat <<EOL >> "$GITIGNORE_FILE"
# Ignore Python bytecode files
__pycache__/
*.py[cod]

# Ignore virtual environment directories
.venv/

# Ignore MyPy cache directory
.mypy_cache/

# Ignore Rope project directory
.ropeproject/

# Ignore IDE/editor specific files
*.swp
*.swo

# Ignore common system files
.DS_Store
Thumbs.db

# Ignore other potential temporary files
*.log
*.tmp
*.swp
EOL

# Add custom file types to the .gitignore file
for FILETYPE in "${FILETYPES[@]}"; do
    echo "*.$FILETYPE" >> "$GITIGNORE_FILE"
done

# Display the content of the .gitignore file using bat
if command -v bat > /dev/null; then
    bat "$GITIGNORE_FILE"
else
    cat "$GITIGNORE_FILE"
fi

