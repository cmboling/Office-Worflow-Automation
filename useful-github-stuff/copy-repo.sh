#!/bin/bash

# Script for generating repositories

set -o errexit
set -o noglob
set -o nounset
set -o pipefail

GH_ORG=ghas-bootcamp
GH_REPO=ghas-bootcamp
# Set GH_USER and GH_TOKEN in your environment

if [ $# -eq 0 ]; then
	echo "usage: GH_USER=... GH_TOKEN=... $0 <username> [<username>...]"
	exit 1
fi

# Rather than put in proper logging, let's just use bash's debugging...
set -o xtrace

git config --local user.name "$GH_USER"
git config --local user.email "$GH_EMAIL"

test -d "$GH_REPO.git" || git clone --bare "https://$GH_USER:$GH_TOKEN@github.com/$GH_ORG/$GH_REPO.git"
cd "$GH_REPO.git"

for username in $@
do
	username="${username//@}"
	new_repo="new-repo-$username"
	curl \
		--verbose \
		--user "$GH_USER:$GH_TOKEN" \
		--header 'Accept: application/vnd.github.v3+json' \
		--data "{ \"name\": \"$new_repo\", \"private\": true, \"has_issues\": true, \"has_wiki\": false, \"has_projects\": false }" \
		"https://api.github.com/orgs/$GH_ORG/repos"
	curl \
		--verbose \
		--user "$GH_USER:$GH_TOKEN" \
		--header 'Accept: application/vnd.github.v3+json' \
		--request PUT \
		--data "{ \"permission\": \"admin\" }" \
		"https://api.github.com/repos/$GH_ORG/$new_repo/collaborators/$username"
	git push --mirror "https://$GH_USER:$GH_TOKEN@github.com/$GH_ORG/$new_repo.git"
done

cd ..
rm -rf "$GH_REPO.git"
echo OK
