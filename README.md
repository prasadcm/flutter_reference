# flutter_reference

Flutter reference workspace. It demonstrate the usage of modular architecture for building flutter apps.
It uses reusable flutter packages, modules in the application.

The reference app inside the apps folder make use of the modules and packages.

It uses a CLI tool melos for managing the project

## How to build and run

### Checkout the code

### Install dependencies

Run the `melos bootstrap` in the root folder.

```sh
    $melos bootstrap
```

### Start an iOS simulator

```sh
    $open -a simulator
```

### Run the app

```sh
    $melos start
```

## How to run the code analysis

On the root of the project, run the `melos analyze` command.

```sh
    $melos analyze
```

## How to run the tests

On the root of the project, run the `melos test` command.

```sh
    $melos test
```

## How to clean all the generated files like build, coverage etc

On the root of the project, run the `melos clean-all` command.

```sh
    $melos clean-all
```

## How to re-generate the anotation classes, mock classes

On the root of the project, run the `melos generate-all` command.

```sh
    $melos generate-all
```

## How to re build the app. Rebuilding will clean all the packages and regenerates it

On the root of the project, run the `melos rebuild-all` command.

```sh
    $melos rebuild-all
```

## How to create a new package

On the root of the project, run the `./scripts/create_package.sh` command.

```sh
    $melos ./scripts/create_package.sh
```

## Best practices

### Monorepo using melos

This project makes use of monorepo with usage of packages, modules and application projects.
It makes use of `melos` as CLI tool.

### Github actions

It defines analyze and test actions

### Pre-commit hooks by huskey
