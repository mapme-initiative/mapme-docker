#!/bin/bash
set -e

while getopts ncpus: flag
do
    case "${flag}" in
        ncpus) NCPUS=${OPTARG};;
    esac
done

NCPUS=${NCPUS:-1}
LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# install sf and terra dev versions
Rscript -e 'remotes::install_github(c("r-spatial/sf", "rspatial/terra", "USDAForestService/gdalraster", "appelmar/gdalcubes"))'

# install r packages as binaries
install2.r --error --skipmissing --skipinstalled --ncpus $NCPUS \
    classInt \
    devtools \
    exactextractr \
    gdalcubes \
    geodata \
    ggplot2 \
    gstat \
    hdf5r \
    here \
    leaflet \
    lwgeom \
    mapview \
    ncdf4 \
    nngeo \
    openxlsx2 \
    proj4 \
    purrr \
    RColorBrewer \
    RNetCDF \
    RPostgreSQL \
    RSQLite \
    rlang \
    sfarrow \
    spacetime \
    spatstat \
    spatialreg \
    spdep \
    stars \
    testthat \
    tmap 
    
# install mapme.biodiversity from CRAN
install2.r --error --skipmissing --skipinstalled --deps TRUE --ncpus $NCPUS mapme.biodiversity
    
# cleanup
rm -r /tmp/downloaded_packages
strip /usr/local/lib/R/site-library/*/libs/*.so

