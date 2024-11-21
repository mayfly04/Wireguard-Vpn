#!/bin/bash

# Script to update Helm chart version only if the branch is 'main'
# Usage: ./update_helm_chart_main.sh <chart_name> [major|minor|patch|show]

set -e

# Configurations
CHARTS_DIR="./helm-charts"  # Directory containing Helm charts
CHART_NAME=$1              # Helm chart name
COMMAND=${2:-show}         # Command: major, minor, patch, or show
CHART_PATH="$CHARTS_DIR/$CHART_NAME/Chart.yaml"

# Ensure the script is being run on the 'main' branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [[ "$CURRENT_BRANCH" != "main" ]]; then
    echo "Error: This script can only be run on the 'main' branch. Current branch: $CURRENT_BRANCH"
    exit 1
fi

# Validate the chart directory and file
if [[ ! -f $CHART_PATH ]]; then
    echo "Error: Chart.yaml not found for chart '$CHART_NAME' in $CHARTS_DIR"
    exit 1
fi

# Extract the current version from Chart.yaml
get_current_version() {
    grep "^version:" "$CHART_PATH" | awk '{print $2}'
}

# Update the version in Chart.yaml
update_chart_version() {
    local new_version=$1
    sed -i "s/^version: .*/version: $new_version/" "$CHART_PATH"
    echo "Updated version in $CHART_PATH to $new_version"
}

# Main script logic
current_version=$(get_current_version)
if [[ -z $current_version ]]; then
    echo "Error: Could not find version in $CHART_PATH"
    exit 1
fi

IFS='.' read -r major minor patch <<< "$current_version"

case $COMMAND in
    major)
        major=$((major + 1))
        minor=0
        patch=0
        ;;
    minor)
        minor=$((minor + 1))
        patch=0
        ;;
    patch)
        patch=$((patch + 1))
        ;;
    show)
        echo "Current version: $current_version"
        exit 0
        ;;
    *)
        echo "Usage: $0 <chart_name> [major|minor|patch|show]"
        exit 1
        ;;
esac

# Generate the new version
new_version="${major}.${minor}.${patch}"

# Update Chart.yaml with the new version
update_chart_version "$new_version"

# Commit and push the changes
git add "$CHART_PATH"
git commit -m "Bump $CHART_NAME version to $new_version"
git push origin main

echo "Changes pushed to branch 'main' with version $new_version"
