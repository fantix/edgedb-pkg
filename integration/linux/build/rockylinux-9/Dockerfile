#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

FROM rockylinux:9

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

ENV LANG C.UTF-8

ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/lib"

RUN (echo precedence ::ffff:0:0/96 100 >> /etc/gai.conf \
    && source /etc/os-release; \
     [ "$VERSION" = "8" ] && (cd /etc/yum.repos.d/ \
    && sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* \
    && yum update -y) || true)

RUN yum install --enablerepo=devel -y \
    wget gcc gcc-c++ make patch zlib-devel openssl-devel sqlite-devel bzip2-devel \
    expat-devel ncurses-devel gdbm-devel readline-devel libuuid-devel \
	curl-devel xz-devel libffi-devel gettext glibc-langpack-en \
    perl-Getopt-Long perl-File-Copy perl-IPC-Cmd perl-Data-Dumper perl-FindBin \
	perl-File-Compare python3.12-pip python3.12-devel \
	systemd-rpm-macros sudo ca-certificates git tar xz cmake


ENV GPG_KEY %%PLACEHOLDER%%
ENV RUSTUP_HOME /usr/local/rustup
ENV CARGO_HOME /usr/local/cargo
ENV PATH /usr/local/cargo/bin:$PATH
ENV RUST_VERSION 1.76.0
ENV NODE_VERSION 16.16.0
ENV YARN_VERSION 1.22.19

RUN set -ex \
    && for key in \
      4ED778F539E3634C779C87C6D7062848A1AB005C \
      141F07595B7B3FFE74309A937405533BE57C7D57 \
      94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
      74F12602B6F1C4E913FAA37AD3A89613643B6201 \
      71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
      8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
      C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
      C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
      DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
      A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
      108F52B48DB57BB0CC439B2997B01419BD92F80A \
      B9E2F5981AA6E0CD28160D9FF13993A75599653C \
    ; do \
      gpg --batch --keyserver hkps://keyserver.ubuntu.com --recv-keys "$key" || \
      gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" ; \
    done \
    && for key in \
      6A010C5166006599AA17F08146C2130DFD2497F5 \
    ; do \
      gpg --batch --keyserver hkps://keyserver.ubuntu.com --recv-keys "$key" || \
      gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" ; \
    done \
	&& curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- \
		-y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION \
	&& chmod -R a+w $RUSTUP_HOME $CARGO_HOME \
	\
	&& dpkgArch="$(rpm --eval '%{_arch}')" \
	&& case "${dpkgArch##*-}" in \
		x86_64) ARCH='x64';; \
		ppc64el) ARCH='ppc64le';; \
		s390x) ARCH='s390x';; \
		arm64) ARCH='arm64';; \
		aarch64) ARCH='arm64';; \
		armhf) ARCH='armv7l';; \
		i386) ARCH='x86';; \
		*) echo "unsupported architecture"; exit 1 ;; \
	esac \
	&& curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
	&& curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
	&& gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
	&& grep " node-v$NODE_VERSION-linux-$ARCH.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
	&& tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
	&& rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
	&& ln -s /usr/local/bin/node /usr/local/bin/nodejs \
	&& curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
	&& curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
	&& gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
	&& mkdir -p /opt \
	&& tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
	&& ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
	&& ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
	&& rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
	&& { command -v gpgconf > /dev/null && gpgconf --kill all || :; } \
	&& rm -rf "$GNUPGHOME" \
	\
	&& python3.12 --version \
	&& rustc --version \
	&& node --version \
	&& npm --version \
	&& yarn --version \
	&& git --version \
	&& tar --version

# make some useful symlinks that are expected to exist
RUN cd /usr/local/bin \
	&& ln -s /usr/bin/python3.12 python3 \
	&& ln -s /usr/bin/python3.12-config python3-config \
	&& ln -s /usr/bin/python3.12 python \
	&& ln -s /usr/bin/python3.12-config python-config

RUN /bin/echo -e '#!/bin/bash\n\
\n\
set -Exeo pipefail\n\
\n\
: "${CARGO_HOME:=$HOME/.cargo}"\n\
\n\
mkdir -p ~/.cache/cargo/{git,registry}\n\
mkdir -p "$CARGO_HOME"\n\
rm -rf "${CARGO_HOME}"/{git,registry}\n\
ln -s ~/.cache/cargo/registry "${CARGO_HOME}/registry"\n\
ln -s ~/.cache/cargo/git "${CARGO_HOME}/git"\n\
\n\
python -m pip install -U git+https://github.com/fantix/edgedb-pkg\n\
\n\
if [ -n "${METAPKG_PATH}" ]; then\n\
    p=$(python -c '\''import metapkg;print(metapkg.__path__[0])'\'')\n\
    rm -rf "${p}"\n\
    ln -s "${METAPKG_PATH}" "${p}"\n\
    ls -al "${p}"\n\
fi\n\
\n\
extraopts=\n\
if [ -n "${SRC_REF}" ]; then\n\
    extraopts+=" --source-ref=${SRC_REF}"\n\
fi\n\
\n\
if [ -n "${BUILD_IS_RELEASE}" ]; then\n\
    extraopts+=" --release"\n\
fi\n\
\n\
if [ -n "${PKG_REVISION}" ]; then\n\
    if [ "${PKG_REVISION}" = "<current-date>" ]; then\n\
        PKG_REVISION="$(date --utc +%Y%m%d%H%M)"\n\
    fi\n\
    extraopts+=" --pkg-revision=${PKG_REVISION}"\n\
fi\n\
\n\
if [ -n "${PKG_SUBDIST}" ]; then\n\
    extraopts+=" --pkg-subdist=${PKG_SUBDIST}"\n\
fi\n\
\n\
if [ -n "${PKG_TAGS}" ]; then\n\
    extraopts+=" --pkg-tags=${PKG_TAGS}"\n\
fi\n\
\n\
if [ -n "${EXTRA_OPTIMIZATIONS}" ]; then\n\
    extraopts+=" --extra-optimizations"\n\
fi\n\
\n\
if [ -n "${BUILD_GENERIC}" ]; then\n\
    extraopts+=" --generic"\n\
fi\n\
\n\
if [ -n "${PKG_BUILD_JOBS}" ]; then\n\
    extraopts+=" --jobs=${PKG_BUILD_JOBS}"\n\
fi\n\
\n\
dest="artifacts"\n\
if [ -n "${PKG_PLATFORM}" ]; then\n\
    dest+="/${PKG_PLATFORM}"\n\
fi\n\
if [ -n "${PKG_PLATFORM_LIBC}" ]; then\n\
    dest+="${PKG_PLATFORM_LIBC}"\n\
    extraopts+=" --libc=${PKG_PLATFORM_LIBC}"\n\
fi\n\
if [ -n "${PKG_PLATFORM_VERSION}" ]; then\n\
    dest+="-${PKG_PLATFORM_VERSION}"\n\
fi\n\
if [ -n "${PKG_PLATFORM_ARCH}" ]; then\n\
    extraopts+=" --arch=${PKG_PLATFORM_ARCH}"\n\
fi\n\
\n\
if [ -z "${PACKAGE}" ]; then\n\
    PACKAGE="edgedbpkg.edgedb:EdgeDB"\n\
fi\n\
\n\
if [ "$1" == "bash" ] || [ "${GET_SHELL}" == "true" ]; then\n\
    echo python -m metapkg build --dest="${dest}" ${extraopts} "${PACKAGE}"\n\
    exec /bin/bash\n\
else\n\
    python -m metapkg build -vvv --dest="${dest}" ${extraopts} "${PACKAGE}"\n\
    ls -al "${dest}"\n\
fi\n\' >/entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
