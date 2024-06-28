import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'Theme/Theme.dart';
import 'ButtonsComponent.dart' as Buttons;


class SportScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final theme = ref.watch(themeNotifierProvider);
    final buttons = Buttons.ButtonsComponent();
    final textStyle = TextStyle(
      color: theme.appBarTheme.titleTextStyle?.color,
    );

    return Center(
      child: Text('Sport Screen'),
    );
  }
}
