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

# Step 3: Ask whether to include BloC
read -p "Do you want to include BloC? [Y/n]: " INCLUDE_BLOC
INCLUDE_BLOC=${INCLUDE_BLOC:-Y} # default is 'Y'

echo "📦 Adding dependencies..."
flutter pub add get_it

# Ensure the dependencies are added in alphabetic order to avoid analyze error
if [[ "$INCLUDE_BLOC" =~ ^[Yy]$ ]]; then
    flutter pub add bloc
fi

flutter pub add equatable


if [[ "$INCLUDE_BLOC" =~ ^[Yy]$ ]]; then
flutter pub add flutter_bloc
fi

echo "📦 Adding dev dependencies..."
if [[ "$INCLUDE_BLOC" =~ ^[Yy]$ ]]; then
flutter pub add --dev bloc_test
fi
flutter pub add --dev build_runner
flutter pub add --dev json_serializable
flutter pub add --dev mocktail
flutter pub add --dev remove_from_coverage
flutter pub add --dev very_good_analysis

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
EOF

echo "✅ Linter rules added to $PACKAGE_NAME/analysis_options.yaml"

echo "✅ Package $PACKAGE_NAME created and set up!"
