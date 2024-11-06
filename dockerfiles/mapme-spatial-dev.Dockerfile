FROM ghcr.io/mapme-initiative/mapme-base:latest

LABEL org.opencontainers.image.title="mapme-spatial-dev" \
      org.opencontainers.image.licenses="GPL-3.0-or-later" \
      org.opencontainers.image.source="https://github.com/mapme.initiative/mapme-docker" \
      org.opencontainers.image.vendor="MAPME Initiative" \
      org.opencontainers.image.description="A build of spatial libraries for use within MAPME" \
      org.opencontainers.image.authors="Darius Görgen <info@dariusgoergen.com>"

COPY scripts/install_rspatial.sh /rocker_scripts/install_rspatial.sh
RUN chmod +x /rocker_scripts/install_rspatial.sh
ARG NCPUS=-1
RUN bash /rocker_scripts/install_rspatial.sh -n $NCPUS -d
