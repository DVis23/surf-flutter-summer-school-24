import 'package:surf_flutter_summer_school_24/src/storage/theme/theme_storage.dart';
import 'package:flutter/material.dart';

class ThemeRepository {
  final ThemeStorage _themeStorage;

  ThemeRepository({
    required ThemeStorage themeStorage,
  }) : _themeStorage = themeStorage;

  Future<void> setThemeMode(
      ThemeMode newThemeMode,
      ) async {
    await _themeStorage.saveThemeMode(
      mode: newThemeMode,
    );
  }

  ThemeMode? getThemeMode() {
    return _themeStorage.getThemeMode();
  }
}