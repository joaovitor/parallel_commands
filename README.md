# Parallel commands

I've being [parallel](https://www.gnu.org/software/parallel/) as a daily tool to execute multiples commands faster.
This has saved me a lot of time and I feel that I need to share something.

## How to use this

Clone the repo and add the `bin` directory to your PATH

## 01- setup

### Pre-requisites

- [gnu-parallel](https://www.gnu.org/software/parallel/)
- [jq](https://stedolan.github.io/jq/)

### Ubuntu install

```shell
sudo apt-get install-y parallel jq
```

### macos install

```shell
brew install parallel jq
```

### Parallel citation

[Official explanation](https://www.gnu.org/software/parallel/parallel_design.html#Citation-notice) on that

```shell
parallel --citation

and then type

will cite
```

## 02- list github repos as a text list

### Token setup

Create a [github user token](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token) with repo:public_repo permission and save it as GITHUB_TOKEN environment variable.

### Github organization repos

```shell
github-print-organization-repos.sh fluxcd fluxcd.txt
```

### Github user repos

```shell
github-print-user-repos.sh joaovitor joaovitor.txt
```

### Day to day use

#### List github organization repos

```shell
mkdir -p ~/github-orgs/fluxcd
cd $_
gh_owner=$(basename $(pwd)); github-print-organization-repos.sh ${gh_owner} ${gh_owner}.txt
```

#### List github user repos

```shell
mkdir -p ~/github-orgs/joaovitor
cd $_
gh_owner=$(basename $(pwd)); github-print-user-repos.sh ${gh_owner} ${gh_owner}.txt
```

#### List azure repositories

```shell
org=$(basename $(pwd)); az devops project list --detect true | \
jq -r '.value[]|.id' | \
parallel -j 10 "az repos list --project {} | jq -r '.[]|.sshUrl'" | \
tee ${org}.txt
```

## 03- Clone repos in parallel

### 3.1 from github

Given that you have a list of repos to be cloned, clone them in parallel.

```shell
cd ~/github-orgs/fluxcd
gh_owner=$(basename $(pwd)); cat ${gh_owner}.txt | parallel  -j 25 'clone-missing.sh {}; echo job {#} completed {};'
```

### 3.2 from azure

```shell
cd ~/azure-study/azuredevopsorg/
az_owner=$(basename $(pwd)); cat ${az_owner}.txt | parallel  -j 25 'azure-clone-missing.sh {}; echo job {#} completed {};'
```

## 04- Pull in parallel

Given that you have a directory with multiple git repositories.

```shell
time update-repos.sh
```

This scripts accepts the depth of nesting directories that needs to have the code updated.

```shell
time update-repos.sh 3
```
