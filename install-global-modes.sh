#!/bin/bash

# Script to install global modes from global-modes directory to custom_modes.yaml
# Dependency: yq (YAML processor) - install with: brew install yq, snap install yq, or download from https://github.com/mikefarah/yq

set -e  # Exit on any error

# Configuration
GLOBAL_MODES_DIR="global-modes"
CUSTOM_MODES_FILE="$HOME/.vscode-server/data/User/globalStorage/rooveterinaryinc.roo-cline/settings/custom_modes.yaml"

# Check if yq is installed
if ! command -v yq &> /dev/null; then
    echo "Error: yq is required but not installed."
    echo "Please install yq using one of these methods:"
    echo "  - macOS: brew install yq"
    echo "  - Linux (snap): snap install yq"
    echo "  - Download: https://github.com/mikefarah/yq"
    echo "  - Go install: go install github.com/mikefarah/yq/v4@latest"
    exit 1
fi

# Check if global-modes directory exists
if [ ! -d "$GLOBAL_MODES_DIR" ]; then
    echo "Error: Global modes directory '$GLOBAL_MODES_DIR' not found."
    exit 1
fi

# Check if custom_modes.yaml exists, create if it doesn't
if [ ! -f "$CUSTOM_MODES_FILE" ]; then
    echo "Creating custom_modes.yaml file at $CUSTOM_MODES_FILE"
    mkdir -p "$(dirname "$CUSTOM_MODES_FILE")"
    cat > "$CUSTOM_MODES_FILE" << EOF
customModes: []
EOF
fi

# Function to check if a mode slug already exists in custom_modes.yaml
mode_exists() {
    local slug="$1"
    # Check if yq returns any output for the slug
    local output
    output=$(yq ".customModes[] | select(.slug == \"$slug\")" "$CUSTOM_MODES_FILE" 2>/dev/null)
    if [ -n "$output" ]; then
        return 0  # Mode exists
    else
        return 1  # Mode doesn't exist
    fi
}

# Function to add a mode to custom_modes.yaml
add_mode() {
    local mode_file="$1"
    local temp_file=$(mktemp)
    
    # Read the mode data and convert it to JSON for proper YAML insertion
    local mode_data=$(yq -o json '.' "$mode_file")
    
    # Use yq to properly add the mode to the customModes array
    yq ".customModes += [$mode_data]" "$CUSTOM_MODES_FILE" > "$temp_file"
    
    # Replace the original file
    mv "$temp_file" "$CUSTOM_MODES_FILE"
}

# Main installation logic
echo "Installing global modes from $GLOBAL_MODES_DIR..."

installed_count=0
skipped_count=0

# Iterate through all YAML files in global-modes directory
for mode_file in "$GLOBAL_MODES_DIR"/*.yaml; do
    if [ ! -f "$mode_file" ]; then
        continue  # Skip if no YAML files found
    fi
    
    # Extract slug from the YAML file
    slug=$(yq '.slug' "$mode_file")
    
    if [ -z "$slug" ]; then
        echo "Warning: No slug found in $mode_file, skipping..."
        continue
    fi
    
    echo "Processing mode: $slug"
    
    # Check if mode already exists
    if mode_exists "$slug"; then
        echo "  ✓ Already installed, skipping..."
        skipped_count=$((skipped_count + 1))
    else
        echo "  + Installing..."
        add_mode "$mode_file"
        installed_count=$((installed_count + 1))
    fi
done

echo ""
echo "Installation complete!"
echo "Installed: $installed_count new modes"
echo "Skipped: $skipped_count existing modes"
echo "Custom modes file: $CUSTOM_MODES_FILE"