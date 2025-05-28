#!/bin/bash

LOG_FILE=".test_output.log"
COVERAGE_THRESHOLD=80

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
dart run remove_from_coverage:remove_from_coverage \
  -f coverage/lcov.info \
  -r '\.g\.dart$'

# Extract coverage percentage
COVERAGE=$(lcov --summary coverage/lcov.info | grep "lines.......:" | awk '{print $2}' | sed 's/%//')

if awk "BEGIN {exit !($COVERAGE < 80)}"; then
    echo "❌ Test coverage is below 80%. Current coverage is $COVERAGE%. Failing the check."
    exit 1
else
    echo "✅ Test coverage meets the requirement. Expected: 80%. Actual: $COVERAGE%"
fi

exit 0
