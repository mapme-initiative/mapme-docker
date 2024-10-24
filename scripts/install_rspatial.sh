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

# install spatial packages from source
install2.r --deps TRUE --ncpus $NCPUS --type source --repos https://cloud.r-project.org \
    sf \
    stars \
    terra \
    gdalcubes \
    mapme.biodiversity 
    
# install mapme packages 
Rscript -e 'remotes::install_github("mapme-initiative/mapme.pipelines", dependencies = TRUE)' 
    
# install additional r packages
install2.r --error --skipmissing --skipinstalled --ncpus $NCPUS \
    countrycodes \
    devtools \
    flextable \
    geodata \
    ggplot2 \
    gstat \
    hdf5r \
    here \
    leaflet \
    logger \
    mapview \
    ncdf4 \
    nngeo \
    openxlsx2 \
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
    targets \
    tmap 

# cleanup
rm -r /tmp/downloaded_packages
strip /usr/local/lib/R/site-library/*/libs/*.so

