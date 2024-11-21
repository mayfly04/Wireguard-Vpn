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


# Extract the chart name from Chart.yaml
CHART_NAME=$(grep '^name:' "$CHART_DIR/Chart.yaml" | awk '{print $2}')
