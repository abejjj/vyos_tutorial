#!/bin/bash

BUILD_TAG=equuleus

cur_dir=$(pwd)

git clone -b ${BUILD_TAG} --single-branch https://github.com/vyos/vyos-build

cd ./vyos-build

docker build -t vyos/vyos-build:${BUILD_TAG} docker 

docker run --rm -it --privileged -v $(pwd):/vyos -w /vyos vyos/vyos-build:${BUILD_TAG} bash -c 'sudo ./configure --architecture amd64 --build-by "whoami@vyos.io" && sudo make iso'


ISOFILE=$(ls  vyos-*-rolling-*.iso)
# echo ${ISOFILE}

sudo mv ./build/*.iso ../

mkdir ../iso

cd ../

ISOFILE=$(ls  vyos-*-rolling-*.iso)

VYOSIMAGE="${ISOFILE//-amd64*.iso}"
# echo "${VYOSIMAGE}"

sudo mount -o loop ${ISOFILE} ./iso 2> /dev/null

mkdir unsquashfs

sudo unsquashfs -f -d unsquashfs/ iso/live/filesystem.squashfs

sudo tar -C ./unsquashfs -c . | docker import - ${VYOSIMAGE}

docker images  --format "{{json . }}" | jq --arg VYOSIMAGE ${VYOSIMAGE} -cr 'select(.Repository == $VYOSIMAGE) | .Repository'

sudo umount ./iso

sudo rm -rf ./unsquashfs
sudo rm -rf ./vyos-build
sudo rm -rf ./iso

