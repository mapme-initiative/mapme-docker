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
Rscript -e 'remotes::install_github(c("r-spatial/sf", "rspatial/terra", "USDAForestService/gdalraster"))'
Rscript -e 'remotes::install_github("mapme-initiative/mapme.biodiversity", ref = "dev")' 

# install r packages as binaries
install2.r --error --skipmissing --skipinstalled -n $NCPUS \
    classInt \
    devtools \
    gdalcubes \
    ggplot2 \
    gstat \
    hdf5r \
    leaflet \
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
    
# cleanup
rm -r /tmp/downloaded_packages
strip /usr/local/lib/R/site-library/*/libs/*.so

