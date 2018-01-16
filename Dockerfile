FROM debian:buster
MAINTAINER JP Limpens <jpmw.limpens@jp-l.org>

# package version
ARG WEBGRAB_VER="2.1"
# user
ARG USR="sc-wg++"
ARG GROUP="sc-wg++"
# application folder
ARG APP_PATH="/home/sc-wg++/wg++"

RUN \
  echo "**** install required packages ****" && \
  apt-get -y update && apt-get install \
  	mono-runtime \
  	libmono-system-data4.0-cil \
  	libmono-system-web4.0-cil \
  	unzip \
  	cron && \
  echo "**** create user, group and homedir ****" && \	
  addgroup ${GROUP} && \
  adduser -D ${USR} && \
  adduser ${USR} ${GROUP} && \
  mkdir -p ${APP_PATH} && \
  echo "**** download WebGrabPlus ****" && \
  curl -o /tmp/wg++.tar.gz -L \ 
  	"http://www.webgrabplus.com/sites/default/files/download/SW/V${WEBGRAB_BRANCH}/WebGrabPlus_V${WEBGRAB_BRANCH}_install.tar.gz" && \
  echo "**** unzip WebGrabPlus ****" && \
  tar -zxzf /tmp/wg++.tar.gz -C ${APP_PATH} --strip-components=1 && \
  echo "**** install WebGrabPlus ****" && \
  ${APP_PATH}/install.sh && \
  echo "**** change owner of path****" && \
  chown -R ${USR}:${GROUP} ${APP_PATH} && \
  echo "**** set crontab file permissions and create a log file ****" && \
  chmod 0644 /etc/cron.d/wg++-cron && \
  touch /var/log/cron.log && \
  echo "**** cleanup for root ****" && \
  rm -rf \
		/tmp/* \
		/var/lib/apt/lists/* \
		/var/tmp/*

# Add crontab file in the cron directory
ADD config/crontab /etc/cron.d/wg++-cron
# Add WebGrab++ config file in the wg++ directory
ADD config/WebGrab++.config.xml ${APP_PATH}/WebGrab++.config.xml

VOLUME ["/data"]
# Run the command on container startup
CMD cron && tail -f /var/log/cron.log
