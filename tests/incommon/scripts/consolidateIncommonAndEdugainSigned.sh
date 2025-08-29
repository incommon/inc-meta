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

# The inc.generate.import_sign_localkey target erroneously depends on sign.uk.keyPassword
# The mda.inc.imported-idp.xml is the parameter for the unsigned idp-only aggregate output file
# The mda.inc.imported.xml is the parameter for the unsigned aggregate output file
ANT_OPTS=(inc.generate.import_sign_localkey \
  "-Dedugain.dir=/mda/inc/inc-meta/mdx/int_edugain" \
  "-Dmda.inc.edugain.xml=tests/incommon/data/test-edugain-metadata.xml" \
  "-Dmda.inc.imported.xml=/tmp/incommon-and-edugain-metadata.xml" \
  "-Dmda.inc.imported-idp.xml=/tmp/incommon-and-edugain-idp-metadata.xml" \
  "-Dmda.inc.production.xml=tests/incommon/data/test-metadata.xml" \
  "-Dmda.sign.keyResource=file:///keys/mda-signing.key" \
  "-Dshared.ws.dir=/mda/inc/inc-meta" \
  "-Dsign.uk.keyPassword=dummypassword")

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
