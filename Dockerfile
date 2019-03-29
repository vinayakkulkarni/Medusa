FROM python:3.7-alpine3.9
LABEL maintainer="pymedusa"

ARG BUILD_DATE
ARG VERSION
LABEL build_version="Version: ${VERSION} Build-date: ${BUILD_DATE}"

# Install packages
RUN \
 apk add --no-cache --virtual=build-dependencies \
	gcc \
	libc-dev \
	linux-headers \
 && \
# Runtime packages
 apk add --no-cache \
	mediainfo \
	unrar \
 && \
# Install Python dependencies
 pip install --upgrade \
	psutil \
 && \
# Cleanup
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/root/.cache \
	/tmp/*

# Install app
COPY . /app/medusa/

# Ports and Volumes
EXPOSE 8081
VOLUME /config /downloads /tv /anime

WORKDIR /app/medusa
CMD [ "python3", "start.py", "--nolaunch", "--datadir", "/config" ]
