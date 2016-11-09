#
# Data Integration Platform As a Service (aka Apache NiFi) Image for Service Foundry Platform
#
# VERSION : 1.0
#
FROM servicefoundry/docker-java

MAINTAINER Service Foundry Team <service.foundry@gmail.com>

ENV REFRESHED_AT 2016-11-11

ENV NIFI_VERSION=1.0.0 \
    NIFI_HOME=/opt/nifi

# Picked recommended mirror from Apache for the distribution.
# Import the Apache NiFi release keys
RUN set -x \
        && curl -Lf https://archive.apache.org/dist/nifi/$NIFI_VERSION/nifi-$NIFI_VERSION-bin.tar.gz -o /tmp/nifi-bin.tar.gz \
        && mkdir -p $NIFI_HOME \
        && tar -z -x -f /tmp/nifi-bin.tar.gz -C $NIFI_HOME --strip-components=1 \
        && rm /tmp/nifi-bin.tar.gz \
        && addgroup nifi \
        && adduser -S -G nifi nifi \
        && bash -c "mkdir -p $NIFI_HOME/{database_repository,flowfile_repository,content_repository,provenance_repository}" \
        && chown nifi:nifi -R $NIFI_HOME

# These are the volumes (in order) for the following:
# 1) user access and flow controller history
# 2) FlowFile attributes and current state in the system
# 3) content for all the FlowFiles in the system
# 4) information related to Data Provenance
# You can find more information about the system properties here - https://nifi.apache.org/docs/nifi-docs/html/administration-guide.html#system_properties
VOLUME ["$NIFI_HOME/database_repository", "$NIFI_HOME/flowfile_repository", "$NIFI_HOME/content_repository", "$NIFI_HOME/provenance_repository"]

# Open port 8081 for the HTTP listen
USER nifi
WORKDIR $NIFI_HOME
EXPOSE 8080 8081
ENTRYPOINT ["bin/nifi.sh"]
CMD ["run"]
