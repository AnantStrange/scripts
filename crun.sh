#!/usr/bin/env zsh

# Check arguments
if [[ $# -ne 1 ]]; then 
    echo "Usage: $(basename "$0") <source.c|source.cpp>"
    exit 1
fi

filename=$1

# Check file exists
if [[ ! -f "$filename" ]]; then
    echo "File not found: $filename"
    exit 1
fi

# Determine file extension
ext="${filename##*.}"   # get text after last dot
base="${filename%.*}"    # remove extension

# Determine compiler
case "$ext" in
    c) compiler="cc" ;;
    cpp) compiler="c++" ;;  # or g++ if you prefer
    *)
        echo "Unsupported file extension: $ext"
        exit 1
        ;;
esac

# Output file
outfile="${base}.out"

includes=()
flags=()
if [[ -f "compile_flags.txt" ]];then
    while IFS= read -r line; do
        if [[ -n "$line" ]]; then
            # [[ "$line" == -I* ]] && includes+=("$line")
            flags+=("$line")
        fi
    done < compile_flags.txt;
fi

echo "$compiler" "$filename" -g "${flags[@]}" -o "$outfile" " && " ./"$outfile"
"$compiler" "$filename" -g -o "$outfile" "${flags[@]}" && ./"$outfile"



