import 'package:flutter/material.dart';
import 'package:sih/widgets/theme/change_theme_widget.dart';
import 'package:sih/widgets/theme/theme_manager.dart';

Future<void> showThemeChangerDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return ThemePickerDialog(
        onSelectedTheme: (BrightnessPreference preference) {
          ThemeManager.of(context).setBrightnessPreference(preference);
        },
      );
    },
  );
}
