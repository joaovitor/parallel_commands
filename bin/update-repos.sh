#!/usr/bin/env bash

update_repos::main(){
    local depth=${1:-2}

    read -r -d '' parallel_commands <<- EOF
git -C {} pull --rebase ;
git -C {} fetch --prune ;
echo job {#} completed {}
EOF
	echo "$parallel_commands"

    find . -maxdepth $depth -name .git -type d -o -type l | \
    sed -e 's%\/\.git%%g' | \
    parallel -j 50 "${parallel_commands}"
}

update_repos::main "$@"
