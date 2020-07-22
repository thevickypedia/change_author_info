#!/bin/sh

if [ $# -ne 1 ]; then
    echo $0: ERROR:
    echo Usage: bash $0 repository
    exit 1
fi

repo=$1

git clone --bare https://github.com/[USER_ID]/$1.git &> /dev/null

echo Cloned the repo $1

cd $1.git

echo Renaming your commits on $1

git filter-branch --env-filter '
OLD_EMAIL="ENTER YOUR EMAIL WHICH HAS TO BE CHANGED"
CORRECT_NAME="NEW USER NAME"
CORRECT_EMAIL="NEW EMAIL ID"
if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags | grep 'WARNING' &> /dev/null

if [ $? == 0 ]; then
	echo "Your branch is up to date.. No changes to push"
else
	echo Pushing changes to GitHub
	git push --force --tags origin 'refs/heads/*'
fi

cd ../

rm -rf $1.git

echo Removed repo
