import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Pages/MainScreen.dart';

void main() {
  runApp(ProviderScope(child: MainScreen()));
}
