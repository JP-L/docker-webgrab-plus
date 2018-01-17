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

VOLUME /data

# Add crontab file in the cron directory
ADD config/crontab /etc/cron.d/wg++-cron
# Add sysctl due to network issue on synology docker
ADD config/sysctl.conf /etc/sysctl.conf
# Add WebGrab++ config file in the wg++ directory
ADD config/WebGrab++.config.xml /tmp/WebGrab++.config.xml

RUN \
  echo "**** install required packages ****" && \
  apt-get -y update && apt-get -y install \
  	mono-runtime \
  	libmono-system-data4.0-cil \
  	libmono-system-web4.0-cil \
  	unzip \
  	curl \
  	psmisc \
  	cron && \
  echo "**** add mono to path ****" && \
  echo PATH=$PATH:/data/myscripts >> /etc/profile && \
	echo export PATH >> /etc/profile && \
  echo "**** create user, group and homedir ****" && \
  addgroup --force-badname ${GROUP} && \
  useradd --home ${HOME} --gid ${GROUP} ${USR} && \
  mkdir -p ${APP_PATH} && \
  echo "**** allow user to write to /data ****" && \
  chown -R ${USR}:${GROUP} /data && \
  echo "**** download WebGrabPlus ****" && \
  curl -o /tmp/wg++.tar.gz -L \
  	"http://www.webgrabplus.com/sites/default/files/download/SW/V${WEBGRAB_VER}.0/WebGrabPlus_V${WEBGRAB_VER}_install.tar.gz" && \
  echo "**** unzip WebGrabPlus ****" && \
  tar -zxvf /tmp/wg++.tar.gz -C ${APP_PATH} --strip-components=1 && \
  echo "**** Make sure shell scripts are executable ****" && \
  chmod -R 755 ${APP_PATH}/install.sh ${APP_PATH}/run.sh ${APP_PATH}/bin/ && \ 
  echo "**** install WebGrabPlus ****" && \
  cd ${APP_PATH} && \
  ${APP_PATH}/install.sh && \
  cd / && \
  echo "**** set WebGrab++.config file ****" && \
  mv /tmp/WebGrab++.config.xml /${APP_PATH}/ && \
  echo "**** change owner of path****" && \
  chown -R ${USR}:${GROUP} ${APP_PATH} && \
  echo "**** set crontab file permissions and create a log file ****" && \
  chmod 0644 /etc/cron.d/wg++-cron && \
  touch /var/log/cron.log && \
  echo "**** cron log ****" >> /var/log/cron.log && \
  echo "**** Fix for cron ****" && \
  /usr/bin/crontab /etc/cron.d/wg++-cron && \
  #echo "**** due to some network issue running the container on synology add net.ipv4.ip_forward=1 to /etc/sysctl.conf ****" && \
  #sed -i "s/^#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/" /etc/sysctl.conf && \
  #sed -i "s/^#net.ipv6.ip_forward=1/net.ipv6.ip_forward=1/" /etc/sysctl.conf && \
  echo "**** cleanup for root ****" && \
  rm -rf \
		/tmp/* \
		/var/lib/apt/lists/* \
		/var/tmp/*
   
# Run the command on container startup
CMD cron && tail -f /var/log/cron.log