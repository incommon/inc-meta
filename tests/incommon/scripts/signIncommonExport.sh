#!/bin/bash
# Sign an input aggregate (e.g. Incommon or eduGAIN)
# but this specifically will test signing the Incommon Export aggregate

ANT_OPTS=(inc.generate.sign_localkey \
  "-Dedugain.dir=/mda/inc/inc-meta/mdx/int_edugain" \
  "-Dmda.inc.imported.xml=/tmp/incommon-export-signed-metadata.xml" \
  "-Dmda.inc.production.xml=tests/incommon/data/test-incommon-export.xml" \
  "-Dmda.sign.keyResource=file:///keys/mda-signing.key" \
  "-Dshared.ws.dir=/mda/inc/inc-meta" \
  "-Dsign.uk.keyPassword=dummypassword")

# Create temp local signing key/cert
SGNPWD=dummypassword
export SGNPWD
mkdir -p /keys
[ ! -L /keys/mda-signing.crt ] && ln -s /$MDQ_HOME/tests/incommon/data/mda-signing.crt /keys/mda-signing.crt
[ ! -L /keys/mda-signing.key ] && ln -s /$MDQ_HOME/tests/incommon/data/mda-signing.key /keys/mda-signing.key

# Download eduGAIN metadata for the MDQ service
echo "Running ant to sign the input metadata file."
cd "$MDQ_HOME" || exit 1
if ! /usr/bin/ant "${ANT_OPTS[@]}"
then
  echo "Download failed"
  exit 1
fi
