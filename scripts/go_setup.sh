#!/bin/bash

# This script sets up the Go environment for the Spinnaker project

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "Go is not installed. Please install Go 1.24 or higher."
    exit 1
fi

# Check Go version
GO_VERSION=$(go version | awk '{print $3}' | sed 's/go//')
GO_MAJOR=$(echo $GO_VERSION | cut -d. -f1)
GO_MINOR=$(echo $GO_VERSION | cut -d. -f2)

if [[ "$GO_MAJOR" -lt 1 || ("$GO_MAJOR" -eq 1 && "$GO_MINOR" -lt 24) ]]; then
    echo "Go version 1.24 or higher is required. You have $GO_VERSION."
    exit 1
fi

echo "Using Go version $GO_VERSION"

# Create go.mod if it doesn't exist
if [ ! -f "go.mod" ]; then
    echo "Creating go.mod file..."
    go mod init github.com/spinnaker/spinnaker
fi

# Add required dependencies
echo "Installing required dependencies..."
go get cloud.google.com/go/compute/metadata
go get golang.org/x/oauth2/google
go get google.golang.org/api/monitoring/v3

# Tidy up dependencies
echo "Tidying dependencies..."
go mod tidy

# Verify modules
echo "Verifying modules..."
go mod verify

echo "Go environment setup complete!"
echo "You can now run tests with: make test"
