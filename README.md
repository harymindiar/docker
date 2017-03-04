# Docker
original from https://github.com/kasperisager/php-dockerized

## What's inside

* [Nginx](http://nginx.org/)
* [MySQL](http://www.mysql.com/)
* [PHP-FPM](http://php-fpm.org/)
* [phalcon](https://github.com/phalcon/cphalcon)
* [Memcached](http://memcached.org/)
* [Redis](http://redis.io/)
* [Elasticsearch](http://www.elasticsearch.org/)

## Requirements

* [Docker Engine](https://docs.docker.com/installation/)
* [Docker Compose](https://docs.docker.com/compose/)
* [Docker Machine](https://docs.docker.com/machine/) (Mac and Windows only)
## Running

Create docker machine named as `default` by using virtualbox driver
```sh
$ docker-machine create -d virtualbox default
```

Another driver is xhyve. What you need is install `docker-machine-driver-xhyve` https://github.com/zchee/docker-machine-driver-xhyve.
```sh
$ docker-machine create -d virtualbox xhyve
```

Set env docker machine and use `default` machine. Please note, this env will lost when you close your terminal. :)
```sh
$ docker-machine env default
```

Docker compose up:

```sh
$ docker-compose up
```

also need NFS for SPEED UP your machine http://www.cameronmaske.com/docker-on-osx/.
