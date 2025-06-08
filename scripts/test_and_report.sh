#!/bin/bash
set -euo pipefail
trap 'echo "❌ Script failed at line $LINENO with exit code $?"' ERR

LOG_FILE=".test_output.log"
COVERAGE_THRESHOLD=80
COVERAGE_FILE="coverage/lcov.info"
EXCLUDE_FILE="coverage_exclude.conf"

PACKAGE_PATH=$1

if [ -z "$PACKAGE_PATH" ]; then
  echo "❌ Error: No package path provided."
  echo "Usage: ./scripts/test_and_report.sh path/to/package"
  exit 1
fi

cd "$PACKAGE_PATH"
PACKAGE=$(basename "$PWD")

echo "📦 Running tests for $PACKAGE"

# Run tests and redirect output to a log file
mkdir -p coverage
flutter test --coverage --reporter expanded --no-color > coverage/.test_output.log 2>&1
TEST_EXIT_CODE=$?

SUMMARY_LINE=$(tail -n 1 coverage/.test_output.log)
echo "📋 Test Summary: $SUMMARY_LINE"

if [ $TEST_EXIT_CODE -ne 0 ]; then
  echo "❌ [$PACKAGE_PATH] Tests failed. You can see the coverage/.test_output.log file for details"
  exit 1
fi

# Check if coverage file exists
if [ ! -f coverage/lcov.info ]; then
  echo "❌ No coverage file found in $PACKAGE_PATH"
  exit 1
fi

# Remove the generated files from coverage
REGEX_ARGS=(
  -r '\.g\.dart$'
)
while IFS= read -r line || [[ -n "$line" ]]; do
  # Ignore empty lines and comments
  [[ -z "$line" || "$line" =~ ^# ]] && continue
  REGEX_ARGS+=("-r" "$line")
done < "$EXCLUDE_FILE"

dart run remove_from_coverage:remove_from_coverage \
  -f "$COVERAGE_FILE" \
  "${REGEX_ARGS[@]}"


# Extract coverage percentage
COVERAGE=$(lcov --summary "$COVERAGE_FILE" | grep "lines.......:" | awk '{print $2}' | sed 's/%//')

if awk -v cov="$COVERAGE" 'BEGIN {exit !(cov < 80)}'; then
    echo "❌ Test coverage is below 80%. Current coverage is $COVERAGE%. Failing the check. Opening coverage report in browser."
    genhtml "$COVERAGE_FILE" -o coverage/html
    open coverage/html/index.html
    exit 1
else
    echo "✅ Test coverage meets the requirement. Expected: 80%. Actual: $COVERAGE%"
fi

exit 0
