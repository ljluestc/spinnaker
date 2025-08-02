.PHONY: test
test:
	go test ./...
.PHONY: all build test clean deps

# Default target
all: build

# Build target
build:
	go build ./...

# Test target
test:
	go test ./... -v

# Test a specific package
test-pkg:
	@read -p "Enter package path: " pkg; \
	go test -v $$pkg

# Clean build artifacts
clean:
	go clean
	rm -rf bin/

# Install dependencies
deps:
	go mod tidy
	go mod download

# Run specific Go files
run:
	@read -p "Enter Go file to run: " file; \
	go run $$file

# Verify dependencies are correctly configured
verify:
	go mod verify

# Generate documentation
docs:
	@echo "Generating documentation..."
	# Add documentation generation commands here

# Format code
fmt:
	go fmt ./...

# Lint code
lint:
	@if command -v golint > /dev/null; then \
		golint ./...; \
	else \
		echo "golint not installed. Installing..."; \
		go install golang.org/x/lint/golint@latest; \
		golint ./...; \
	fi

# Generate mocks for testing
mocks:
	@echo "Generating mocks..."
	# Add mock generation commands here

# Help message
help:
	@echo "Available targets:"
	@echo "  all            - Default target, same as 'build'"
	@echo "  build          - Build the project"
	@echo "  test           - Run all tests"
	@echo "  test-pkg       - Run tests for a specific package"
	@echo "  clean          - Clean build artifacts"
	@echo "  deps           - Install dependencies"
	@echo "  run            - Run a specific Go file"
	@echo "  verify         - Verify dependencies"
	@echo "  docs           - Generate documentation"
	@echo "  fmt            - Format code"
	@echo "  lint           - Lint code"
	@echo "  mocks          - Generate mocks for testing"
	@echo "  help           - Show this help message"
.PHONY: build
build:
	go build ./...

.PHONY: clean
clean:
	rm -rf bin/
