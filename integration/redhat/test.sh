#!/bin/bash

set -ex

yum install -y artifacts/edgedb-server-0*.el7.x86_64.rpm
su edgedb -c '/usr/lib64/edgedb-server/bin/python3 \
             -m edb.tools --no-devmode test /usr/share/edgedb-server/tests \
             -e flake8 --output-format=simple'
systemctl enable --now edgedb-0
[[ "$(echo 'SELECT 1 + 3;' | edgedb -u edgedb)" == *4* ]]
echo "Success!"