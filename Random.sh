repo/
├── charts/
│   ├── chart1/
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   ├── templates/
│   ├── chart2/
│   │   ├── Chart.yaml
│   │   ├── values.yaml
│   │   ├── templates/
├── release.config.js
├── package.json
└── semantic-release-helm.sh




Expected Outputs
Independent Versioning:

Each chart gets its own version based on changes in commits.
Chart.yaml updated in each chart.
Changelog Generation:

CHANGELOG.md for each chart is updated with changes specific to that chart.
Packaged Charts:

Charts are packaged as .tgz files in ./dist.
Published Charts:

Charts are pushed to an OCI registry.




Example Workflow
Commit Messages:

plaintext
Copy code
feat(chart1): add support for feature X
fix(chart2): resolve an issue with Y
chore(chart1): update documentation
Resulting Versions:

chart1: 1.2.0 (based on feat)
chart2: 1.1.1 (based on fix)
CHANGELOG.md (chart1):

markdown
Copy code
# Changelog

## [1.2.0] - YYYY-MM-DD
### Features
- add support for feature X
CHANGELOG.md (chart2):

markdown
Copy code
# Changelog

## [1.1.1] - YYYY-MM-DD
### Bug Fixes
- resolve an issue with Y





# Check if helm lint was successful
if [ $? -ne 0 ]; then
  echo "Helm lint check failed."
  exit 1
fi

echo "Helm lint check passed."


# Extract the chart name from Chart.yaml
CHART_NAME=$(grep '^name:' "$CHART_DIR/Chart.yaml" | awk '{print $2}')








#!/bin/bash

# Ensure script is run from a Git repository
if ! git rev-parse --is-inside-work-tree &>/dev/null; then
  echo "Error: This script must be run from inside a Git repository."
  exit 1
fi

# Branch to analyze (default: development)
BRANCH=${1:-"development"}

# Fetch the latest changes from the branch
git fetch origin "$BRANCH" &>/dev/null || {
  echo "Error: Failed to fetch branch $BRANCH."
  exit 1
}

# Get the latest commit hash on the specified branch
LAST_COMMIT=$(git rev-parse origin/"$BRANCH") || {
  echo "Error: Could not find branch $BRANCH."
  exit 1
}

echo "Analyzing last commit on branch '$BRANCH': $LAST_COMMIT"

# List all changed paths in the root directory from the last commit
CHANGED_FOLDERS=$(git diff-tree --no-commit-id --name-only -r "$LAST_COMMIT" | \
  awk -F'/' '$2 == "" {print $1}' | sort -u)

# Output the results
if [[ -z "$CHANGED_FOLDERS" ]]; then
  echo "No subfolders in the root directory were changed."
else
  echo "Subfolders in the root directory changed in the last commit:"
  echo "$CHANGED_FOLDERS"
fi

#!/bin/bash

# Fetch the last commit hash from the development branch
last_commit=$(git rev-parse development)

# List changed files in the last commit
changed_files=$(git diff-tree --no-commit-id --name-only -r $last_commit)




#!/bin/bash

# Directory where Helm charts are located
CHARTS_DIR="charts"

# Get the list of changed directories
CHANGED_DIRS=$(git diff --name-only HEAD^ HEAD | grep "^${CHARTS_DIR}/" | cut -d '/' -f 2 | sort | uniq)

# Loop through each changed directory
for DIR in $CHANGED_DIRS; do
  CHART_DIR="${CHARTS_DIR}/${DIR}"

  # Check if it's a directory
  if [ ! -d "$CHART_DIR" ]; then
    continue
  fi

  echo "Processing $CHART_DIR..."

  # Bump the version
  VERSION=$(grep '^version:' $CHART_DIR/Chart.yaml | awk '{print $2}')
  NEW_VERSION=$(echo $VERSION | awk -F. -v OFS=. '{$NF += 1 ; print}')
  sed -i "s/^version: .*/version: $NEW_VERSION/" $CHART_DIR/Chart.yaml

  # Generate changelog
  git log --pretty=format:"* %s (%h)" -- $CHART_DIR > $CHART_DIR/CHANGELOG.md

  # Commit changes
  git add $CHART_DIR/Chart.yaml $CHART_DIR/CHANGELOG.md
  git commit -m "chore: bump version and update changelog for $DIR"
done

# List unique subfolders under the root directory
echo "$changed_files" | grep -o '^[^/]*/' | sort -u
