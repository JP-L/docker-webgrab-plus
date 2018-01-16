FROM debian:buster
MAINTAINER JP Limpens <jpmw.limpens@jp-l.org>

# package version
ARG WEBGRAB_VER="2.1"
# user
ARG USR="sc-wg++"
ARG GROUP="xmltv"
ARG HOME="/home/${USR}"
# application folder
ARG APP_PATH="${HOME}/wg++"

# Add crontab file in the cron directory
ADD config/crontab /etc/cron.d/wg++-cron

RUN \
  echo "**** install required packages ****" && \
  apt-get -y update && apt-get -y install \
  	mono-runtime \
  	libmono-system-data4.0-cil \
  	libmono-system-web4.0-cil \
  	unzip \
  	curl \
  	cron && \
  echo "**** create user, group and homedir ****" && \	
  addgroup --force-badname ${GROUP} && \
  useradd --home ${HOME} --gid ${GROUP} ${USR} && \
  mkdir -p ${APP_PATH} && \
  echo "**** download WebGrabPlus ****" && \
  curl -o /tmp/wg++.tar.gz -L \
  	"http://www.webgrabplus.com/sites/default/files/download/SW/V${WEBGRAB_VER}.0/WebGrabPlus_V${WEBGRAB_VER}_install.tar.gz" && \
  echo "**** unzip WebGrabPlus ****" && \
  tar -zxvf /tmp/wg++.tar.gz -C ${APP_PATH} --strip-components=1 && \
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

# Add WebGrab++ config file in the wg++ directory
ADD config/WebGrab++.config.xml ${APP_PATH}/WebGrab++.config.xml

# Run the command on container startup
CMD cron && tail -f /var/log/cron.log
