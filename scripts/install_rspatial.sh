#!/bin/bash
set -e

DEV=0

while getopts "dn:" flag
do
    case "${flag}" in
        n) NCPUS=${OPTARG};;
        d) DEV=1;;
    esac
done

NCPUS=${NCPUS:-1}
LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# install spatial packages from source
install2.r --deps TRUE --ncpus $NCPUS --type source --repos https://cloud.r-project.org \
    sf \
    stars \
    terra \
    gdalcubes
    
# install mapme.biodiversity dev or cran version
if [ $DEV -eq 1 ]; then
  echo "Installing dev version of mapme.biodiversity"
  Rscript -e 'remotes::install_github("mapme-initiative/mapme.biodiversity", dependencies = TRUE)'
else
  echo "Installing CRAN version of mapme.biodiversity"
  install2.r --deps TRUE --ncpus $NCPUS --type source --repos https://cloud.r-project.org \
    mapme.biodiversity
fi

# install other mapme packages from github
Rscript -e 'remotes::install_github("mapme-initiative/mapme.pipelines", dependencies = TRUE)'
    
# install additional r packages
install2.r --error --skipmissing --skipinstalled --ncpus $NCPUS \
    countrycode \
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

