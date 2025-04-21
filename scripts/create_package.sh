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

if [[ "$INCLUDE_BLOC" =~ ^[Yy]$ ]]; then
    echo "📦 Adding BloC dependencies..."
    flutter pub add bloc
    flutter pub add flutter_bloc
    flutter pub add equatable
    flutter pub add --dev bloc_test
fi
flutter pub add --dev build_runner json_serializable
flutter pub add --dev mockito


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
cat <<EOF > analysis_options.yaml
linter:
    rules:
        prefer_const_constructors: true
        prefer_const_literals_to_create_immutables: true
        prefer_const_declarations: true
        prefer_const_constructors_in_immutables: true

        prefer_final_fields: true
        prefer_final_locals: true
        prefer_final_parameters: true
        prefer_final_in_for_each: true

        unnecessary_const: true
        unnecessary_late: true

        # Code Clarity
        always_declare_return_types: true
        always_put_required_named_parameters_first: true
        use_super_parameters: true
        avoid_returning_null: true

        # Type Safety & Best Practices
        avoid_dynamic_calls: true
        avoid_print: true

        # Flutter-specific
        use_key_in_widget_constructors: true
        avoid_unnecessary_containers: true
        sized_box_for_whitespace: true

        # Collections & Literals
        prefer_collection_literals: true
        prefer_spread_collections: true

        public_member_api_docs: false # Set to true for packages
        package_api_docs: false # Set to true for packages
        sort_pub_dependencies: true
EOF
echo "✅ Linter rules added to $PACKAGE_NAME/analysis_options.yaml"

echo "✅ Package $PACKAGE_NAME created and set up!"
