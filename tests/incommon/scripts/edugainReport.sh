#!/bin/bash
# Report on the eduGAIN entities filtered out because of errors detected.

ANT_OPTS=(inc.edugain.report_local \
  "-Dshared.ws.dir=/mda/inc/inc-meta" \
  "-Dedugain.dir=/mda/inc/inc-meta/mdx/int_edugain" \
  "-Dmda.inc.edugain.xml=tests/incommon/data/test-edugain-metadata.xml")

# Download eduGAIN metadata for the MDQ service
echo "Running ant to report on the eduGAIN metadata file."
cd "$MDQ_HOME" || exit 1
if ! /usr/bin/ant "${ANT_OPTS[@]}"
then
  echo "Download failed"
  exit 1
fi
