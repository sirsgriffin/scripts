#!/bin/bash

set -o pipefail

function check-hardtabs {
    local found_hardtab=0

    for file in $@; do
        od -c "$file" | grep '\\t' > /dev/null

        if [ $? -eq 0 ]; then
            echo "$file: FAILED"
            found_hardtab=$(( found_hardtab + 1))
        else
            echo "$file: passed"
        fi
    done

    return $found_hardtab
} 


if [ $# -eq 0  ]; then
    echo "Checking files staged for commit for hardtabs..."
    repo_root=$(git rev-parse --show-toplevel)/
    added_files=$(git diff-index --name-only --cached HEAD | sed "s:^:$repo_root:") 

    check-hardtabs "${added_files[@]}" | column -t
else
    check-hardtabs "$@" | column -t
fi

exit "${PIPESTATUS[0]}"
