#!/usr/bin/env bash

set -euo pipefail

clone_missing::main(){
    local git_remote_repo="$1"
    local d=""
    d=$(echo "${git_remote_repo}" | cut -d / -f 3-4);
    if [[ ! -d "$d" ]] ; then
        git clone "${git_remote_repo}" "${d}";
    fi
}

clone_missing::main "$@"
