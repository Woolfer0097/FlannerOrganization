
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Pages/Theme/Theme.dart';
import 'Pages/MainScreen.dart';

void main() {
  runApp(ProviderScope(child: MainScreen()));
}

import 'package:flutter/material.dart';
import 'package:flanner/MainScreen.dart';

void main() {
  runApp(MainScreen());
}
