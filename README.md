# Parallel commands

I've being [parallel](https://www.gnu.org/software/parallel/) as a daily tool to execute multiples commands faster.
This has saved me a lot of time and I feel that I need to share something.

## How to use this

Clone the repo and add the `bin` directory to your PATH

## 01- setup

### Ubuntu install

```shell
sudo apt-get install parallel
```

### Parallel setup

```shell
echo 'will cite' | parallel --citation 1
```

## 02- git txt list

### Token setup

Create a [github user token](https://docs.github.com/en/free-pro-team@latest/github/authenticating-to-github/creating-a-personal-access-token) with repo:public_repo permission and save it as GITHUB_TOKEN environment variable.

### Organization repos

```shell
github-print-organization-repos.sh fluxcd fluxcd.txt
```

### User repos

```shell
github-print-user-repos.sh joaovitor joaovitor.txt
```

### Day to day use

#### List organization repos

```shell
mkdir -p ~/github-orgs/fluxcd
cd $_
gh_owner=$(basename $(pwd)); github-print-organization-repos.sh ${gh_owner} ${gh_owner}.txt
```

#### List user repos

```shell
mkdir -p ~/github-orgs/joaovitor
cd $_
gh_owner=$(basename $(pwd)); github-print-user-repos.sh ${gh_owner} ${gh_owner}.txt
```

## 03- Clone repos in parallel

Given that you have a list of repos to be cloned, clone them in parallel.

```shell
cd ~/github-orgs/fluxcd
gh_owner=$(basename $(pwd)); cat ${gh_owner}.txt | parallel  -j 25 'clone-missing.sh {}; echo job {#} completed {};'
```

## 04- Pull in parallel

Given that you have a directory with multiple git repositories.

```shell
time update-repos.sh
```
