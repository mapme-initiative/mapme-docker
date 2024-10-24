#!/bin/bash
set -e
# get PROJ, GEOS, and GDAL versions from the build context
while getopts proj:geos:gdal:ncpus: flag
do
    case "${flag}" in
        proj) PROJ_VERSION=${OPTARG};;
        geos) GEOS_VERSION=${OPTARG};;
        gdal) GDAL_VERSION=${OPTARG};;
        ncpus) NCPUS=${OPTARG};;
    esac
done

NCPUS=${NCPUS:-1}
PROJ_VERSION=${PROJ_VERSION:latest}
GEOS_VERSION=${GEOS_VERSION:latest}
GDAL_VERSION=${GDAL_VERSION:latest}


if [ "$PROJ_VERSION" = "latest" ]; then
    PROJ_VERSION=$(wget -qO- 'https://api.github.com/repos/OSGeo/PROJ/git/refs/tags' | grep -oP '(?<="ref":\s"refs/tags/)\d+\.\d+\.\d+' | tail -n -1)
fi

if [ "$GEOS_VERSION" = "latest" ]; then
    GEOS_VERSION=$(wget -qO- 'https://api.github.com/repos/libgeos/geos/git/refs/tags' | grep -oP '(?<="ref":\s"refs/tags/)\d+\.\d+\.\d+' | tail -n -1)
fi

if [ "$GDAL_VERSION" = "latest" ]; then
    GDAL_VERSION=$(wget -qO- 'https://api.github.com/repos/OSGeo/gdal/git/refs/tags' | grep -oP '"ref":\s"refs/tags/v\d+\.\d+\.\d+"' | grep -oP '\d+\.\d+\.\d+' | tail -n -1)
fi

CMAKE_CORES=${NCPUS}
if [ "${CMAKE_CORES}" = "-1" ]; then
    CMAKE_CORES=$(nproc --ignore=1)
fi

echo "Installing PROJ at version ${PROJ_VERSION}"
echo "Installing GEOS at version ${GEOS_VERSION}"
echo "Installing GDAL at version ${GDAL_VERSION}"
echo "Building with cmake using ${CMAKE_CORES} cores"

export DEBIAN_FRONTEND=noninteractive

apt-get update && apt-get install -y software-properties-common
add-apt-repository ppa:ubuntugis/ubuntugis-unstable
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
apt-key  adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
apt-get update && apt-get upgrade -y

# only install if no already installed (from rocker)
function apt_install() {
    if ! dpkg -s "$@" >/dev/null 2>&1; then
        if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
            apt-get update
        fi
        apt-get install -y --no-install-recommends "$@"
    fi
}

apt_install \
        libavfilter-dev \
        libcairo2-dev \
        libblosc-dev \
        libcurl4-openssl-dev \
        libexpat1-dev \
        libpq-dev \
        libsqlite3-dev \
        libudunits2-dev \
        lbzip2 \
        libfftw3-dev \
        libgsl0-dev \
        libgl1-mesa-dev \
        libglu1-mesa-dev \
        libhdf4-alt-dev \
        libhdf5-dev \
        libjq-dev \
        libkml-dev \
        libpq-dev \
        libprotobuf-dev \
        libnetcdf-dev \
        libssl-dev \
        libtiff5-dev \
        libopenjp2-7-dev \
        libxml2-dev \
        libssh2-1-dev \
        libgit2-dev \
        libtiff-dev \
        cmake \
        cargo \
        locales \
        netcdf-bin \
        postgis \
        unixodbc-dev \
        protobuf-compiler \
        sqlite3 \
        tk-dev \
        htop \
        screen \
        wget \
        nano
        
# install DVC
wget https://dvc.org/deb/dvc.list -O /etc/apt/sources.list.d/dvc.list \
  && wget -qO - https://dvc.org/deb/iterative.asc | gpg --dearmor > packages.iterative.gpg \
  && install -o root -g root -m 644 packages.iterative.gpg /etc/apt/trusted.gpg.d \
  && rm -f packages.iterative.gpg \
  && apt update \
  && apt install dvc 
        
# geoparquet sysdeps
wget https://apache.jfrog.io/artifactory/arrow/"$(lsb_release --id --short | tr '[:upper:]' '[:lower:]')"/apache-arrow-apt-source-latest-"$(lsb_release --codename --short)".deb \
  && apt_install -y -V ./apache-arrow-apt-source-latest-"$(lsb_release --codename --short)".deb \
  && apt-get update \
  && apt-get install -y -V libarrow-dev libparquet-dev libarrow-dataset-dev	

locale-gen en_US.UTF-8

LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
mkdir builds \
  && cd builds 
  
# GEOS
wget -q http://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2 \
  && bzip2 -d geos-${GEOS_VERSION}.tar.bz2 \
  && tar xf geos-${GEOS_VERSION}.tar \
  && cd geos-${GEOS_VERSION} \
  && mkdir build \
  && cd build \
  && cmake -DCMAKE_BUILD_TYPE=Release .. \
  && cmake --build . --parallel $CMAKE_CORES --target install \
  && ldconfig \
  && cd ../.. 

# PROJ
wget -q http://download.osgeo.org/proj/proj-${PROJ_VERSION}.tar.gz \
  && tar zxvf proj-${PROJ_VERSION}.tar.gz \
  && cd proj-${PROJ_VERSION} \
  && mkdir build \
  && cd build \
  && cmake -DCMAKE_BUILD_TYPE=Release .. \
  && cmake --build . --parallel $CMAKE_CORES --target install \
  && ldconfig \
  && cd ../.. 

# pull in datum and transformation data, as we are mostly "offline"  
# projsync --system-directory --all

# GDAL
wget -q http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz \
  && tar -xf gdal-${GDAL_VERSION}.tar.gz \
  && cd gdal-${GDAL_VERSION} \
  && mkdir build \
  && cd build \
  && cmake -DCMAKE_BUILD_TYPE=Release .. \
  && cmake --build . --parallel $CMAKE_CORES --target install \
  && ldconfig \
  && cd ../.. 
  
cd .. \
  && rm -rf builds
  
# cleanup  
rm -rf /var/lib/apt/lists/*

