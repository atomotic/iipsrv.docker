# iipsrv.docker

[iipsrv](https://github.com/ruven/iipsrv) in single docker container. Compiled with openjpeg, so it can serve JPEG2000 images. Also including [caddy](https://github.com/atomotic/iipsrv.docker/blob/main/Caddyfile) (for an http interface) and memcached.   
The main purpose of this image is local development of IIIF applications.

Ready images (x86_64 and aarch64) are available on [docker hub](https://hub.docker.com/r/atomotic/iipsrv) (+300 MB compressed).

## Usage

1. Clone this repo

        git clone https://github.com/atomotic/iipsrv.docker.git

2. Configure the [host directory](https://github.com/atomotic/iipsrv.docker/blob/main/docker-compose.yml#L14) containing your images (ptiff, jp2) and mount in `/images`
3. Configure iipsrv via [ENV](https://github.com/atomotic/iipsrv.docker/blob/main/docker-compose.yml#L7-L12). See here the documentation [Server Configuration / Startup variables](https://iipimage.sourceforge.io/documentation/server/#configuration) 

4. Launch it

        docker-compose up --build -d 

5. Test it

        curl -s http://localhost:9002/iiif/image.jp2/info.json



