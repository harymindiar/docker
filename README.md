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

Create docker machine named as `default`
```sh
$ docker-machine create -d virtualbox default
```

you can check list of docker machine by run
```sh
$ docker-machine ls
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
