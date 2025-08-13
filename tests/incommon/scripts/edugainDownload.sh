#!/bin/bash
# Download metadata files required for the MDQ service

ANT_OPTS=(inc.edugain.download \
  "-Dshared.ws.dir=/mda/inc/inc-meta" \
  "-Dedugain.dir=/mda/inc/inc-meta/mdx/int_edugain" \
  "-Dmda.inc.edugain.xml=/tmp/edugain-metadata.xml")

# Download eduGAIN metadata for the MDQ service
echo "Running ant to download the eduGAIN metadata file."
cd "$MDQ_HOME" || exit 1
if ! /usr/bin/ant "${ANT_OPTS[@]}"
then
  echo "Download failed"
  exit 1
fi
