import 'package:categories/categories.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:network/network.dart';

import 'app.dart';

void main() {
  CoreServiceLocator.setup();
  NetworkServiceLocator.setup();
  CategoryServiceLocator.setup();
  runApp(
    const ReferenceApp(),
  );
}
