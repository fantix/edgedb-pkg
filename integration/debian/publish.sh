#!/bin/bash

set -e

mkdir -p "${HOME}/.ssh" && chmod 700 "${HOME}/.ssh"
echo "${DPUT_SSH_KEY}" > "${HOME}/.ssh/id_ed25519"
chmod 400 "${HOME}/.ssh/id_ed25519"

cat <<EOF >"${HOME}/.ssh/config"
Host upload-packages.prod.edgedatabase.net
    Port 2222
    StrictHostKeyChecking no
EOF

set -ex

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y dput python3-paramiko

cat <<EOF >/tmp/dput.cf
[edgedb-prod]
fqdn                    = upload-packages.prod.edgedatabase.net
login                   = uploader
allow_dcut              = 1
method                  = sftp
allow_unsigned_uploads  = 1
post_upload_command     = post_upload_command="ssh reprepro@upload-packages.prod.edgedatabase.net -- /usr/bin/reprepro processincoming"
EOF

dput -d -d -c /tmp/dput.cf edgedb-prod artifacts/*.changes
