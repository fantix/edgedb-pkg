#!/bin/sh

set -ex

dest="artifacts"
if [ -n "${PKG_PLATFORM}" ]; then
    dest="${dest}/${PKG_PLATFORM}"
fi
if [ -n "${PKG_PLATFORM_VERSION}" ]; then
    dest="${dest}-${PKG_PLATFORM_VERSION}"
fi
if [ -n "${PKG_TEST_JOBS}" ]; then
    dash_j="-j${PKG_TEST_JOBS}"
else
    dash_j=""
fi

wget "https://packages.edgedb.com/dist/x86_64-unknown-linux-musl/edgedb-cli" \
    -O /bin/edgedb
chmod +x /bin/edgedb

tarball=
for pack in ${dest}/*.tar; do
    if [ -e "${pack}" ]; then
        tarball=$(tar -xOf "${pack}" "build-metadata.json" \
                  | jq -r ".installrefs[]" \
                  | grep ".tar.gz$")
        if [ -n "${tarball}" ]; then
            break
        fi
    fi
done

if [ -z "${tarball}" ]; then
    echo "${dest} does not contain a valid build tarball" >&2
    exit 1
fi

mkdir /edgedb
chmod 1777 /tmp
tar -xOf "${pack}" "${tarball}" | tar -xzf- --strip-components=1 -C "/edgedb/"
touch /etc/group
addgroup edgedb
touch /etc/passwd
adduser -G edgedb -H -D edgedb

if [ "$1" == "bash" ]; then
    exec /bin/sh
fi

exec gosu edgedb:edgedb /edgedb/bin/python3 \
    -m edb.tools --no-devmode test \
    /edgedb/data/tests \
    -e cqa_ -e tools_ \
    --verbose ${dash_j}