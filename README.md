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
    $cd apps\reference
    $flutter run
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
