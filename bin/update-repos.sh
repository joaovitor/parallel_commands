#!/usr/bin/env bash

update_repos::main(){
    local depth=${1:-2}

    read -r -d '' parallel_commands <<- EOF
git -C {} pull --rebase --prune;
echo job {#} completed {}
EOF
	echo "$parallel_commands"
    find . -maxdepth "${depth}" \( -type l -o -type d \) -exec test -e '{}/.git' ';' -print -prune | \
    parallel --retry-failed --retries 3 -j 55 "${parallel_commands}"
}

update_repos::main "$@"
