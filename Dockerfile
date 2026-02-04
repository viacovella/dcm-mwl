# Base image with Java 17 JRE on Ubuntu Jammy
FROM eclipse-temurin:17-jre-jammy

# Metadata labels
LABEL maintainer="Vittorio Iacovella vittorio.iacovella@unitn.it"
LABEL description="DICOM toolkit dcm4che setup on Ubuntu with Java 17"

# Install basic utilities
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    vim \
    && rm -rf /var/lib/apt/lists/*

# This puts dcmche version in an environment variable for easy updates
ENV DCM4CHE_VERSION=5.33.0
WORKDIR /opt

# This should work thanks to the naming convention of dcm4che maintainers, but if it doesn't, you can always download the zip file manually and copy it into the Docker image
RUN wget -q https://sourceforge.net/projects/dcm4che/files/dcm4che3/${DCM4CHE_VERSION}/dcm4che-${DCM4CHE_VERSION}-bin.zip/download -O dcm4che.zip \
    && unzip -q dcm4che.zip \
    && mv dcm4che-${DCM4CHE_VERSION} dcm4che \
    && rm dcm4che.zip

# update the path to include dcm4che binaries
ENV PATH="/opt/dcm4che/bin:${PATH}"
ENV DCM4CHE_HOME="/opt/dcm4che"

# let's create a workspace directory for the worklist space
WORKDIR /workspace

# Expose the default DICOM port used by dcm4che tools
EXPOSE 11112

# This is just to keep the container running for interactive use
CMD ["/bin/bash"]