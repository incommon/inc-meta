#!/bin/bash
# Generate metadata files required for the MDQ service

# TODO:
#   * Wrap mda output in debug function
#   * Count files

set -euo pipefail

# Get script name
PROG=`basename $0`

# Get metadata validation funtions
source /$MDQ_HOME/tests/incommon/scripts/metadataValidation.sh

# Print debug output
function debug {
  echo [DEBUG] $PROG: "$@"
}

# Print error output
function error {
  echo [ERROR] $PROG: "$@"
}

# Print informational output
function info {
  echo [INFO] $PROG: "$@"
}

info "Starting at $(date)"

# Use local key
debug "Using local key"
# The inc.mdq.generate.all.localkey target erroneously depends on sign.uk.keyPassword
ANT_OPTS=(inc.mdq.generate.all.localkey \
  "-Dshared.ws.dir=/mda/inc/inc-meta" \
  "-Dmda.sign.keyResource=file:///keys/mda-signing.key" \
  "-Dmda.inc.imported.xml=tests/incommon/data/test-metadata-signed.xml" \
  "-Dsign.uk.keyPassword=dummypassword")

# Set source for signed InCommon metadata aggregate
MD_SOURCE_FILE=$MDQ_HOME/tests/incommon/data/test-metadata-signed.xml
MD_SOURCE_CERT=/$MDQ_HOME/tests/incommon/data/test-cert.pem

debug "Verifying source metadata signature"
# Get the timestamp from the metadata aggregate file
MDTIME=$(stat -c %y "$MD_SOURCE_FILE" | cut -d ' ' -f1,2)
export MDTIME

# Verify the signature on the metadata aggregate
args=(--verifySignature \
  --inFile "$MD_SOURCE_FILE" \
  --certificate "$MD_SOURCE_CERT" \
  --outFile "$INC_MD_VERIFIED_PATH")
if ! "$XMLSECTOOL_PATH" "${args[@]}"
then
  error "Source metadata signature verification failed"
  exit 1
fi

rm -f /tmp/inc-metadata.xml

# Create temp local signing key/cert
SGNPWD=dummypassword
export SGNPWD
mkdir -p /keys
[ ! -L /keys/mda-signing.crt ] && ln -s /$MDQ_HOME/tests/incommon/data/mda-signing.crt /keys/mda-signing.crt
[ ! -L /keys/mda-signing.key ] && ln -s /$MDQ_HOME/tests/incommon/data/mda-signing.key /keys/mda-signing.key

# Generate all required metadata for the MDQ service
debug "Generating metadata"
cd "$MDQ_HOME" || exit 1
if ! /usr/bin/ant "${ANT_OPTS[@]}"
then
  error "Metadata generation failed"
  exit 1
fi
