![lufi](https://fiat-tux.fr/wp-content/uploads/lufi196.png)

[![Build Status](https://drone.xataz.net/api/badges/xataz/docker-lufi/status.svg)](https://drone.xataz.net/xataz/docker-lufi)
[![](https://images.microbadger.com/badges/image/xataz/lufi.svg)](https://microbadger.com/images/xataz/lufi "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/xataz/lufi.svg)](https://microbadger.com/images/xataz/lufi "Get your own version badge on microbadger.com")

> This image is build and push with [drone.io](https://github.com/drone/drone), a circle-ci like self-hosted.
> If you don't trust, you can build yourself.

## Tag available
* latest [(lufi/Dockerfile)](https://github.com/xataz/dockerfiles/blob/master/lufi/Dockerfile)

## Description
What is [lufi](https://git.framasoft.org/luc/lufi) ?

Lufi means Let's Upload that FIle.

It stores files and allows you to download them.

Is that all? No. All the files are encrypted by the browser! It means that your files never leave your computer unencrypted. The administrator of the Lufi instance you use will not be able to see what is in your file, neither will your network administrator, or your ISP.

**This image not contains root process**

## BUILD IMAGE

```shell
docker build -t xataz/lufi github.com/xataz/dockerfiles.git#master:lufi
```

## Configuration
### Environments
* UID : Choose uid for launch lufi (default : 991)
* GID : Choose gid for launch lufi (default : 991)
* WEBROOT : webroot of lufi (default : /)
* SECRET : random string used to encrypt cookies (default : 0423bab3aea2d87d5eedd9a4e8173618)
* MAX_FILE_SIZE : maximum file size of an uploaded file in bytes (default : 10000000000)
* CONTACT : lufi contact (default : contact@domain.tld)
* DEFAULT_DELAY : default time limit for files in days (default : 1 (0 for unlimited))
* MAX_DELAY : number of days after which the images will be deleted (default : 0 for unlimited)

Tips : you can use the following command to generate SECRET. `date +%s | md5sum | head -c 32`

### Volumes
* /usr/lufi/data : lufi's database is here
* /usr/lufi/files : Location of uploaded files
* /usr/lufi/themes : Location of themes

### Ports
* 8081

## Usage
### Simple launch
```shell
docker run -d -p 8081:8081 xataz/lufi
```
URI access : http://XX.XX.XX.XX:8081

### Advanced launch
```shell
docker run -d -p 8181:8081 \
	-v /docker/config/lufi/data:/data \
    -v /docker/data/lufi:/files \
	-e UID=1001 \
	-e GID=1001 \
    -e WEBROOT=/lufi \
    -e SECRET=$(date +%s | md5sum | head -c 32) \
    -e CONTACT=contact@mydomain.com \
    -e MAX_FILE_SIZE=250000000 \
	xataz/lufi
```
URI access : http://XX.XX.XX.XX:8181/lufi

## Contributing
Any contributions, are very welcome !
