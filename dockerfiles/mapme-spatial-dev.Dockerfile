FROM ghcr.io/mapme-initiative/mapme-base:latest

LABEL org.opencontainers.image.licenses="GPL-3.0-or-later" \
      org.opencontainers.image.source="https://github.com/mapme.initiative/mapme-docker" \
      org.opencontainers.image.vendor="MAPME Initiative" \
      org.opencontainers.image.description="A build of spatial libraries for use within MAPME" \
      org.opencontainers.image.authors="Darius Görgen <info@dariusgoergen.com>"

COPY scripts/install_rspatial_dev.sh /rocker_scripts/install_rspatial_dev.sh
RUN chmod +x /rocker_scripts/install_rspatial_dev.sh
ARG NCPUS=-1
RUN bash /rocker_scripts/install_rspatial_dev.sh -ncpus $NCPUS
