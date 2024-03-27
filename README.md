# mapme-docker


This repository is builds a docker images with the latest releases of [GDAL](https://github.com/OSGeo/gdal/releases), 
[PROJ](https://github.com/OSGeo/proj/releases), and [GEOS](https://github.com/libgeos/geos/releases) as well as a selection of recent version of R spatial packages.

The docker images are published here:
[https://github.com/mapme.initiative/mapme-spatial/pkgs/container/mapme-spatial](https://github.com/mapme.initiative/mapme-docker/pkgs/container/mapme-spatial)

The images are based on [rocker](https://rocker-project.org/). If you wanted to run
R Studio on `localhost:8787` run:

```bash
docker run --rm -p 8787:8787 -e PASSWORD=supersecret ghcr.io/mapme.initiative/mapme-docker:mapme-spatial
```

To build the docker image locally run:

```bas
docker build -f dockerfiles/mapme-spatial.Dockerfile -t mapme-spatial:latest .
```

