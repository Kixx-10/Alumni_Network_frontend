import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_notifier.g.dart';
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
@override
  ThemeMode build() {
    return ThemeMode.light;//default light
  }
  void toggleTheme(bool isDark) {
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}