FROM amazonlinux:2023.5.20240730.0

# Install necessary packages
RUN dnf -y install \
    # these switches are used to force full java-17-corretto dependencies installation
    ant -x java-22-amazon-corretto-headless -x java-21-amazon-corretto-headless \
    # awscli \
    tar \
    gzip \
    openssl \
    unzip \
    wget \
    which \
  && dnf clean all

RUN mkdir -p /mda/inc/inc-meta
COPY . /mda/inc/inc-meta

# Set environment variables
#
# Note: XMLSECTOOL_PATH specifies the path to the xmlsectool installed with the
#       metadata aggregator. We use xmlsectool in startup.sh, but that will no
#       longer be required if we update the inc-meta MDA rules to check the
#       signature of the source aggregate.
ENV INC_MD_VERIFIED_PATH=/metadata/inc-metadata.xml \
  XMLSECTOOL_PATH=/mda/inc/inc-meta/tools/xmlsectool-3.0.0/xmlsectool.sh \
  JAVA_HOME=/ \
  JVMOPTS=-Xmx2048m \
  MDQ_HOME=/mda/inc/inc-meta/ \
  WWW_HOME=/mdqwww \
  CERTGEN_MDQSIGN_SUBJECT=/C=US/ST=State/L=City/O=OrgName/CN=mdqsigning.example.org \
  CERTGEN_WWW_SUBJECT=/C=US/ST=State/L=City/O=OrgName/CN=mdqweb.example.org

# Create metadata output directory
RUN mkdir /metadata

# CMD ["/usr/local/bin/startup.sh"]
