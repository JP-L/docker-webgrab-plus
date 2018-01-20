
[jplorgurl]: https://www.jp-l.org
[appurl]: http://www.webgrabplus.com/
[hub]: https://hub.docker.com/r/jplorg/webgrabplus/

TODO: add logo

[JP-L][jplorgurl] created a WebGrabPlus container.

Latest release: 0.1 - docker-webgrab-plus - [Changelog](CHANGELOG.md)
# jplorg/webgrabplus
[![](https://images.microbadger.com/badges/version/jplorg/webgrabplus.svg)](https://microbadger.com/images/jplorg/webgrabplus "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/jplorg/webgrabplus.svg)](https://microbadger.com/images/jplorg/webgrabplus "Get your own image badge on microbadger.com")
[![Docker Pulls](https://img.shields.io/docker/pulls/jplorg/webgrabplus.svg)][hub][![Docker Stars](https://img.shields.io/docker/stars/jplorg/webgrabplus.svg)][hub]
TODO: Add shippable and code quality status

[![webgrabplus]][appurl]

WebGrab+Plus is a multi-site incremental xmltv epg grabber. It collects tv-program guide data from selected tvguide sites for your favourite channels.

## Quick Start

```
docker create \
  --name=WebGrabPlus \
  --net=bridge \
  -v <path to config>:/home/sc-wg++/wg++/WebGrab++.config.xml \
  -v <path to epg>:/epg \
  -v <path to siteini.user>:/siteini.user \
  jplorg/webgrabplus
```
You can choose between ,using tags, latest (default, and no tag required or a specific release branch of WebGrab+Plus. Add one of the tags, if required, to the jplorg/webgrabplus line of the run/create command in the following format, jplorg/webgrabplus:release-1.0

#### Tags

+ **latest** : latest release from official WebGrab+Plus 4.2 branch.

## Donations
Please consider donating a cup of coffee for the developer through paypal using the button below.

[![Donate](https://www.dokuwiki.org/lib/exe/fetch.php?w=220&tok=95f428&media=https%3A%2F%2Fraw.githubusercontent.com%2Ftschinz%2Fdokuwiki_paypal_plugin%2Fmaster%2Flogo.jpg)](https://www.paypal.me/JPLORG/2,50EUR)

## Considerations

* The container is based on Debian. For shell access whilst the container is running do `docker exec -it webgrabplus /bin/bash`.
* Container local time is default set to Europe/Amsterdam. This can be changed using `-e TZ` (where TZ is eg Europe/Berlin).
* Currently the container grabs EPG data at 10:04 and 22:04. This will be configurable in the future.

## Usage

**Parameters**

The parameters are split into two halves, separated by a colon, the left hand side representing the host and the right the container side. 
For example with a port -p external:internal - what this shows is the port mapping from internal to external of the container.
So -p 8080:80 would expose port 80 from inside the container to be accessible from the host's IP on port 8080
http://172.12.x.x:8080 would show you what's running INSIDE the container on port 80.

* `-v /WebGrab++.config.xml` - WebGrab+Plus configuration file
* `-v /epg` - Where WebGrab+Plus stores the guide.xml file
* `-v /siteini.users` - Where you can use your own siteini files
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation
* `--net=bridge` 
* `-e TZ` - for timezone information *eg Europe/London, etc*

**User / Group Identifiers**

When using volumes (`-v` flags) permission issues arise between the host OS and the container. This can be avoided by specifying the user `PUID` and group `PGID`. 
Ensure the volumes directories on the host are read/writable by the container user. The container user is hts which is part of the groups video and users.

In this instance `PUID=103` and `PGID=44`. To find yours use `id user` as below:

```
  $ id <dockeruser>
    uid=103(dockeruser) gid=44(dockergroup) groups=44(dockergroup)
```

## Info

* Shell access whilst the container is running: `docker exec -it webgrabplus /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f webgrabplus`

* container version number 

`docker inspect -f '{{ index .Config.Labels "build_version" }}' webgrabplus`

* image version number

`docker inspect -f '{{ index .Config.Labels "build_version" }}' jplorg/webgrabplus`


## Versions

+ **xx.xx.xx:** Initial release.

## Changelog

Please refer to: [CHANGELOG.md](CHANGELOG.md)
