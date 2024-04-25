#!/bin/bash

if [ $# -eq 2 ]; then
    input_dir=$1
    output_dir=$2
else
    echo "Неправильный запуск скрипта!"
    echo "Пример: $0 входная директория выходная директория"
    exit 1
fi

sub_dirs=()
files=()

while IFS= read -r dir; do
    sub_dirs+=("$dir")
done <(find "$input_dir" -type d)

for dir in "${sub_dirs[@]}"; do
    while IFS= read -r file; do
        files+=("$file")
    done < <(find "$dir" -maxdepth 1 -type f)
done

file_check() {
    local file_path=$1
    local file="${file_path##*/}"
    local name="${file%.*}"
    local ext="${file##*.}"

    if [[ "$file" != *.* ]]; then
        ext=""
    else
        ext=".$ext"
    fi

    local count=1
    local new_file="$output_dir/$name$ext"
    while [ -f "$new_file" ]; do
        new_file="$output_dir/$name($count)$ext"
        ((count++))
    done

    echo "$new_file"
}

for file in "${files[@]}"; do
    file_dst=$(file_check "$output_dir/$(basename "$file")")
    cp "$file" "$file_dst"
done
