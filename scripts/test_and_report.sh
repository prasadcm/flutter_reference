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
set +e  # Allow command to fail without exiting the script
trap - ERR  # Disable trap
flutter test --coverage --reporter expanded --no-color > coverage/.test_output.log 2>&1
TEST_EXIT_CODE=$?
set -e # Re-enable exit-on-error
trap 'echo "❌ Script failed at line $LINENO with exit code $?"' ERR  # Re-enable trap

if [ $TEST_EXIT_CODE -ne 0 ]; then
  echo "❌ [$PACKAGE_PATH] Some tests failed. You can see the coverage/.test_output.log file for details"
  exit 1
fi

SUMMARY_LINE=$(tail -n 1 coverage/.test_output.log)
echo "📋 Test Summary: $SUMMARY_LINE"

# Check if coverage file exists
if [ ! -f $COVERAGE_FILE ]; then
  echo "❌ No coverage file found in $PACKAGE_PATH"
  exit 1
fi

# Remove the generated files from coverage
REGEX_ARGS=(
  -r '\.g\.dart$'
)

if [[  -f "$EXCLUDE_FILE" ]]; then
  while IFS= read -r line || [[ -n "$line" ]]; do
    # Ignore empty lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    REGEX_ARGS+=("-r" "$line")
  done < "$EXCLUDE_FILE"
fi

dart run remove_from_coverage:remove_from_coverage \
  -f "$COVERAGE_FILE" \
  "${REGEX_ARGS[@]}"


# Extract coverage percentage
SUMMARY_OUTPUT=$(lcov --summary "$COVERAGE_FILE" 2>&1) || {
  echo "❌ lcov summary failed:"
  echo "$SUMMARY_OUTPUT"
  exit 1
}

LINE_COVERAGE_LINE=$(echo "$SUMMARY_OUTPUT" | grep -E '^\s*lines.*:' || true)
if [[ -z "$LINE_COVERAGE_LINE" ]]; then
  echo "❌ Could not find line coverage info in lcov summary output:"
  echo "$SUMMARY_OUTPUT"
  exit 1
fi

COVERAGE=$(echo "$LINE_COVERAGE_LINE" | awk '{print $2}' | sed 's/%//')

if awk -v cov="$COVERAGE" -v threshold="$COVERAGE_THRESHOLD" 'BEGIN {exit !(cov >= threshold)}'; then
  echo "✅ Test coverage meets the requirement. Expected: $COVERAGE_THRESHOLD%. Actual: $COVERAGE%"
else
  echo "❌ Test coverage is below $COVERAGE_THRESHOLD%. Current coverage is $COVERAGE%. Failing the check. Opening coverage report in browser."
  genhtml "$COVERAGE_FILE" -o coverage/html
  open coverage/html/index.html
  exit 1
fi

exit 0
