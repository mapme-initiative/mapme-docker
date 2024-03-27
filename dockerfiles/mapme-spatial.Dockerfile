FROM rocker/verse:4.3.2

LABEL org.opencontainers.image.licenses="GPL-3.0-or-later" \
      org.opencontainers.image.source="https://github.com/mapme.initiative/mapme-docker" \
      org.opencontainers.image.vendor="MAPME Initiative" \
      org.opencontainers.image.description="A build of spatial libraries for use within MAPME" \
      org.opencontainers.image.authors="Darius Görgen <info@dariusgoergen.com>"

COPY scripts/install_sysdeps.sh /rocker_scripts/install_sysdeps.sh
COPY scripts/install_rspatial.sh /rocker_scripts/install_rspatial.sh

RUN chmod +x /rocker_scripts/install_sysdeps.sh
RUN chmod +x /rocker_scripts/install_rspatial.sh

ARG PROJ_VERSION=latest
ARG GEOS_VERSION=latest
ARG GDAL_VERSION=latest
ARG NCPUS=-1

RUN bash /rocker_scripts/install_sysdeps.sh -proj $PROJ_VERSION -geos $GEOS_VERSION -gdal $GDAL_VERSION -ncpus $NCPUS
RUN bash /rocker_scripts/install_rspatial.sh -ncpus $NCPUS
