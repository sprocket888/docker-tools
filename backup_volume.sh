#!/bin/bash
# This script allows you to backup a single volume
# Data in given volume is saved in the current directory in a tar archive.

VOLUME_NAME=$1
ARCHIVE_NAME=$2

usage() {
  echo "Usage: $0 [volume name] [output filename]"
  exit 1
}

if [ -z $VOLUME_NAME ]
then
  echo "Error: missing volume name parameter."
  usage
fi

if [ -z $ARCHIVE_NAME ]
then
  echo "Error: missing output file name parameter."
  usage
fi

docker run --rm -v $(pwd):/dest_volume -v ${VOLUME_NAME}:/source_volume busybox tar czvf /dest_volume/${ARCHIVE_NAME}.tar.gz -C /source_volume .
