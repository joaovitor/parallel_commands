#!/usr/bin/env bash

github_print_organization_repos::main(){
    local GITHUB_OWNER="${1}"
    local output_file="${2:-repos.txt}"

    if [[ -z "$GITHUB_OWNER" ]]; then
        echo "Undefined GITHUB_OWNER variable"
        github_print_organization_repos::usage
    fi

    if [[ -z "$GITHUB_TOKEN" ]]; then
        echo "Undefined GITHUB_TOKEN variable"
        github_print_organization_repos::usage
    fi

    local per_page=100
    local page=1
    local returned_repos=0
    local temp_file=""
    temp_file=$(mktemp)

    local org_verification=""
    local url_prefix=""

    org_verification=$(
        curl -H "Authorization: token $GITHUB_TOKEN" \
            -H "Accept: application/vnd.github.v3+json" \
            -o /dev/null \
            -LI \
            -w "%{http_code}\n" \
            -s "https://api.github.com/orgs/${GITHUB_OWNER}"
    )

    if [[ ! "${org_verification}" -eq "200" ]]; then
        echo "invalid organization [$GITHUB_OWNER]"
        github_print_organization_repos::usage
    fi

    while [ ${page} -eq 1 ] || [ ${returned_repos} -ge ${per_page} ]; do
        curl -H "Authorization: token $GITHUB_TOKEN" -s "https://api.github.com/orgs/${GITHUB_OWNER}/repos?per_page=${per_page}&amp;page=${page}" -o "${temp_file}"
        returned_repos=$(jq '. | length' "${temp_file}")
        jq -r '.[] | select(.archived == false) | .ssh_url ' "${temp_file}" >> "${output_file}"
        page=$((${page}+1))
    done

    sort -u -o "${output_file}" "${output_file}"
    cat "${output_file}"
}

github_print_organization_repos::usage(){
  echo "USAGE: $0 GITHUB_OWNER outputfile"
  exit 2
}

github_print_organization_repos::main "$@"
