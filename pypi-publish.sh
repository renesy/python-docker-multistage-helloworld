#!/usr/bin/env sh
set -e

# Read file .pypiuser from current directory or home
if [ -f .pypiuser ]
then
    pypiuser=$(cat ./.pypiuser)
elif [ -f ~/.pypiuser ]
then
    pypiuser=$(cat ~/.pypiuser)
else
    echo "Please create ./.pypiuser or ~/.pypiuser with your PyPi username"
    echo "Then store your password using keyring:"
    echo "% keyring set https://upload.pypi.org/legacy/ USERNAME"
    echo "% keyring set https://test.pypi.org/legacy/ USERNAME"
    exit 1
fi

# remove previously, maybe failed builds
rm -rf dist

# build a new distribution
python setup.py sdist bdist_wheel

# check for production release flag
if [ "$1" = "prod" ]
then
    url="https://upload.pypi.org/legacy/"
else
    url="https://test.pypi.org/legacy/"
fi

# set password using command: keyring set URL USERNAME
password=$(keyring get "$url" "$pypiuser")
twine upload -u "$pypiuser" -p "$password" --repository-url "$url" dist/*

# clean up
rm -rf dist
