#!/bin/sh
#!/bin/bash

# Post-installation script for Halyard

set -e

# Create required directories
mkdir -p /var/log/spinnaker/halyard
mkdir -p /var/lib/halyard
mkdir -p /opt/halyard/config

# Set proper permissions
chown -R spinnaker:spinnaker /var/log/spinnaker/halyard
chown -R spinnaker:spinnaker /var/lib/halyard
chown -R spinnaker:spinnaker /opt/halyard/config

# Create symlinks for AWS CLI if needed
if [ ! -e /usr/bin/aws ] && [ -e /usr/local/bin/aws ]; then
    ln -sf /usr/local/bin/aws /usr/bin/aws
fi

# Install AWS CLI if not present
if ! command -v aws &> /dev/null; then
    echo "AWS CLI not found, installing..."
    pip3 install --upgrade awscli==1.33.2 urllib3==2.2.2
    aws --version
else
    echo "AWS CLI already installed:"
    aws --version
fi

# Enable and start Halyard service
if command -v systemctl &> /dev/null; then
    systemctl daemon-reload
    systemctl enable halyard
    systemctl start halyard
    echo "Halyard service started"
else
    echo "systemctl not found, cannot start Halyard service automatically"
    echo "Please start the service manually"
fi

echo "Halyard post-installation complete!"
echo '#!/usr/bin/env bash' | sudo tee /usr/local/bin/hal > /dev/null
echo '/opt/halyard/bin/hal "$@"' | sudo tee -a /usr/local/bin/hal > /dev/null

chmod +x /usr/local/bin/hal

if [ -f "/opt/spinnaker/config/halyard-user" ];
then
  HAL_USER=$(cat /opt/spinnaker/config/halyard-user)
else
  HAL_USER=spinnaker
  # Temporarily prevent commands that return non-zero exit codes
  # from causing the post installation to fail.
  set +e
  getent passwd spinnaker > /dev/null
  GETENT_RESULT=$?
  # Reenable checking for non-zero exit codes.
  set -e
  if [ $GETENT_RESULT -ne 0 ]; then
    useradd -s /bin/bash $HAL_USER --create-home
  fi
  if [ ! -f "/opt/spinnaker/config/halyard-user" ];
  then
    mkdir -p /opt/spinnaker/config
    chown -R spinnaker:spinnaker /opt/spinnaker
    echo ${HAL_USER} > /opt/spinnaker/config/halyard-user
  fi
fi

install --mode=755 --owner=$HAL_USER --group=$HAL_USER --directory /var/log/spinnaker/halyard

systemctl restart halyard
