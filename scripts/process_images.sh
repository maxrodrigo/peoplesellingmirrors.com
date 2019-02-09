#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

images_path="./images"
images_json="./images.json"
files=''

for file in $images_path/*; do
    file_hash=$(md5 -q $file)
    file_extension="${file##*.}"
    new_file="${images_path}/${file_hash}.${file_extension}"

    if [[ "$file" != "$new_file" && "$file" != "$images_json" ]]; then
      echo "$file → $new_file"
      mv $file $new_file
    fi
    # The first braces expand to $files and the comma if files is set already
    # otherwise to nothing
    files=${files:+${files},}\"${new_file}\"

done

printf '{"images":[%s]}' "$files" > "${images_json}"
