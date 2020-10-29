#!/usr/bin/env bash

clone_missing::main(){
    local git_remote_repo="$1"
    local d=""
    d=$(echo "${git_remote_repo}" | cut -d / -f 2 | cut -d '.' -f 1);
    if [[ ! -d "$d" ]] ; then
        git clone "${git_remote_repo}";
    fi
}

clone_missing::main "$@"
