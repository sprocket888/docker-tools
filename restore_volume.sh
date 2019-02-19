#!/bin/bash
# This script allows you to restore a single volume from a container
# Data in restored in volume with same backupped path

VOLUME_NAME=$1
ARCHIVE_NAME=$2

usage() {
  echo "Usage: $0 [volume name] [archive to restore]"
  exit 1
}

if [ -z $VOLUME_NAME ]
then
  echo "Error: missing volume name parameter."
  usage
fi

if [ -z $ARCHIVE_NAME ]
then
  echo "Error: missing volume name parameter."
  usage
fi

# Check to see if the file exists
if [ ! -f ${ARCHIVE_NAME} ]; then
    echo "Error: Cannot find file " ${ARCHIVE_NAME}
    exit
fi


while true; do
    echo ""
    echo "!!! WARNING !!!"
    echo ""
    echo "This will remove all data from volume: "
    echo "      " ${VOLUME_NAME} 
    read -p  "Do you wish to continue? (Y/N)?" yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

#Check to see if the volume exists
if docker volume ls | grep -wq ${VOLUME_NAME} ; then
    echo "VOLUME DELETED"
fi

docker volume create ${VOLUME_NAME}
echo "VOLUME CREATED"

docker run --rm -v ${VOLUME_NAME}:/dst_volume -v $(pwd):/src_volume busybox tar xvf /src_volume/${ARCHIVE_NAME} -C /dst_volume
