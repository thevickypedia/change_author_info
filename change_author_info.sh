#!/bin/sh

git clone --bare https://github.com/[Account_ID]/[repo name].git &> /dev/null

cd [repo name].git

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

cd ../

rm -rf [repo name].git
