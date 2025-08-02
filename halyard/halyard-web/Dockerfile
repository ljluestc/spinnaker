FROM alpine:3.16 as java-builder
RUN apk add --update --no-cache openjdk11 bash
FROM ubuntu:20.04

LABEL maintainer="sig-platform@spinnaker.io"

# Environment variables
ENV KUBECTL_RELEASE=1.22.0
ENV AWS_CLI_VERSION=1.33.2
ENV URLLIB3_VERSION=2.2.2

# Install dependencies
RUN apt-get update && apt-get install -y \
    openjdk11-jdk \
    python3 \
    python3-pip \
    curl \
    unzip \
    git \
    wget \
    ca-certificates \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI with specific versions to avoid dependency issues
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir --upgrade \
    awscli==${AWS_CLI_VERSION} \
    urllib3==${URLLIB3_VERSION}

# Verify AWS CLI installation
RUN aws --version

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_RELEASE}/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# Create spinnaker user
RUN useradd -m spinnaker -U

# Setup proper permissions
RUN mkdir -p /home/spinnaker/.hal && \
    mkdir -p /home/spinnaker/.kube && \
    chown -R spinnaker:spinnaker /home/spinnaker

# Set working directory
WORKDIR /home/spinnaker

# Copy halyard JAR
COPY ./build/install/halyard /opt/halyard

# Add halyard to PATH
ENV PATH=$PATH:/opt/halyard/bin

# Expose API port
EXPOSE 8064

# Set the default command
CMD ["java", "-jar", "/opt/halyard/lib/halyard-web.jar"]
FROM java-builder as halyard-builder
COPY . /opt/halyard/
WORKDIR /opt/halyard
RUN ./gradlew halyard-web:installDist -x test

FROM ubuntu:20.04
LABEL maintainer="sig-platform@spinnaker.io"

# Environment variables
ENV KUBECTL_RELEASE=1.22.0
ENV AWS_CLI_VERSION=1.33.2
ENV URLLIB3_VERSION=2.2.2

# Copy from builder
COPY --from=halyard-builder /opt/halyard/halyard-web/build/install/halyard /opt/halyard

# Install dependencies
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    curl \
    unzip \
    git \
    wget \
    ca-certificates \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI with specific versions to avoid dependency issues
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir --upgrade \
    awscli==${AWS_CLI_VERSION} \
    urllib3==${URLLIB3_VERSION}

# Verify AWS CLI installation
RUN aws --version

# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_RELEASE}/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# Create spinnaker user
RUN useradd -m spinnaker -U

# Setup proper permissions
RUN mkdir -p /home/spinnaker/.hal && \
    mkdir -p /home/spinnaker/.kube && \
    chown -R spinnaker:spinnaker /home/spinnaker

# Set working directory and user
WORKDIR /home/spinnaker
USER spinnaker

# Add halyard to PATH
ENV PATH=$PATH:/opt/halyard/bin

# Expose API port
EXPOSE 8064

# Set the entrypoint
ENTRYPOINT ["hal"]
CMD ["--help"]
