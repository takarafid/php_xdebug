NAME=php_xdebug
VERSION=php56
DOCKER_RUN_OPTIONS= \
	--privileged \
	--net=docker-lan \
	--ip=192.168.100.2 \
	-p 80:80 \
	-p 3307:3306 \
	-v `pwd`/mysql:/var/lib/mysql \
	-v `pwd`/src:/var/www/html

include docker.mk
