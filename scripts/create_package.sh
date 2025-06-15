#!/bin/bash

# Step 1: Get the package name
read -p "Package name: " PACKAGE_NAME

if [ -z "$PACKAGE_NAME" ]; then
    echo "❌ Please provide a package name."
    exit 1
fi

PACKAGE_PATH="packages/$PACKAGE_NAME"

# Step 2: Create the package
flutter create --template=package $PACKAGE_PATH
cd $PACKAGE_PATH

# Insert publish_to: "none" after the description line in pubspec.yaml
sed -i '' '/^description:/a\
publish_to: "none"\
' pubspec.yaml

# Remove all comment lines
sed -i '' '/^[[:space:]]*#/d' pubspec.yaml

# Step 3: Ask whether to include BloC
read -p "Do you want to include BloC? [Y/n]: " INCLUDE_BLOC
INCLUDE_BLOC=${INCLUDE_BLOC:-Y} # default is 'Y'

echo "📦 Adding dependencies..."

# Add local packages - core, network
awk '/^dependencies:/ {
    print;
    print "  core:";
    print "    path: ../../packages/core";
    print "  network:";
    print "    path: ../../packages/network";
    next
} 1' pubspec.yaml > pubspec.new.yaml && mv pubspec.new.yaml pubspec.yaml

# Add common dependencies
flutter pub add dartz
flutter pub add equatable get_it json_annotation

# Ensure the dependencies are added in alphabetic order to avoid analyze error
if [[ "$INCLUDE_BLOC" =~ ^[Yy]$ ]]; then
    flutter pub add bloc flutter_bloc
fi

echo "📦 Adding dev dependencies..."
flutter pub add --dev build_runner json_serializable mocktail remove_from_coverage very_good_analysis
if [[ "$INCLUDE_BLOC" =~ ^[Yy]$ ]]; then
flutter pub add --dev bloc_test
fi

# Step 4: Add standard folder structure
echo "📦 Adding standard folder structure..."
cd lib
mkdir -p src
if [[ "$INCLUDE_BLOC" =~ ^[Yy]$ ]]; then
    mkdir -p src/bloc
    mkdir -p src/data
fi
mkdir -p src/presentation
echo "✅ Standard folders created in $PACKAGE_NAME/lib/src"

# Step 5: Add linter rules
echo "📦 Adding linter rules ..."
cat <<EOF > ../analysis_options.yaml
include: package:very_good_analysis/analysis_options.yaml

linter:
  rules:
    public_member_api_docs: false
    avoid_final_parameters: false
    prefer_final_locals: true
    prefer_final_fields: true
    prefer_if_elements_to_conditional_expressions: false
    lines_longer_than_80_chars: false
    document_ignores: false
    unnecessary_lambdas: false

analyzer:
  exclude:
    - test/**/mock_*.dart
    - test/**/mocks/*.dart
    - lib/**.g.dart

EOF

# Add coverage exclusion config file
touch coverage_exclude.conf

echo "✅ Linter rules added to $PACKAGE_NAME/analysis_options.yaml"

echo "✅ Package $PACKAGE_NAME created and set up!"

echo "📦 Please visit the pubspec.yaml file and rearrange the dependencies in the alphabatic order."

