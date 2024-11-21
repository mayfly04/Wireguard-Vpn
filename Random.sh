{
  "branches": ["main"],
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/changelog",
    [
      "@semantic-release/exec",
      {
        "prepareCmd": "helm package . -d ../output && helm repo index ../output"
      }
    ],
    [
      "@semantic-release/git",
      {
        "assets": ["CHANGELOG.md", "*.tgz", "Chart.yaml"],
        "message": "chore(release): ${nextRelease.version} [skip ci]\n\n${nextRelease.notes}"
      }
    ]
  ]
}

FROM node:14-alpine

# Install dependencies
RUN apk add --no-cache bash curl git

# Install semantic-release and its plugins
RUN npm install -g semantic-release @semantic-release/git @semantic-release/changelog @semantic-release/exec

# Set the working directory
WORKDIR /usr/src/app

# Copy the semantic-release configuration file
COPY .releaserc /usr/src/app/.releaserc

ENTRYPOINT ["semantic-release"]





#!/bin/bash

set -e

# Define the Helm charts directories
CHARTS=("chart1" "chart2")

# Loop through each chart directory
for CHART in "${CHARTS[@]}"; do
  echo "Processing $CHART..."

  # Change to the chart directory
  cd "$CHART"

  # Run semantic-release for the chart
  npx semantic-release

  # Change back to the root directory
  cd ..
done



{
  "branches": ["main"],
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/changelog",
    "@semantic-release/git",
    "@semantic-release/exec"
  ]
}
