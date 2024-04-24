FROM rocker/verse:4.3.2

LABEL org.opencontainers.image.licenses="GPL-3.0-or-later" \
      org.opencontainers.image.source="https://github.com/mapme.initiative/mapme-docker" \
      org.opencontainers.image.vendor="MAPME Initiative" \
      org.opencontainers.image.description="A build of spatial libraries for use within MAPME" \
      org.opencontainers.image.authors="Darius Görgen <info@dariusgoergen.com>"

COPY scripts/install_sysdeps.sh /rocker_scripts/install_sysdeps.sh
COPY scripts/install_rspatial_dev.sh /rocker_scripts/install_rspatial_dev.sh

RUN chmod +x /rocker_scripts/install_sysdeps.sh
RUN chmod +x /rocker_scripts/install_rspatial_dev.sh

ARG PROJ_VERSION=9.4.0
ARG GEOS_VERSION=3.12.1
ARG GDAL_VERSION=3.8.5
ARG NCPUS=-1

RUN bash /rocker_scripts/install_sysdeps.sh -proj $PROJ_VERSION -geos $GEOS_VERSION -gdal $GDAL_VERSION -ncpus $NCPUS
RUN bash /rocker_scripts/install_rspatial_dev.sh -ncpus $NCPUS
