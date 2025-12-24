import 'package:flutter/material.dart';

// Selection de theme disponible dans l'app.
enum AppThemeSelection {
  system,
  light,
  dark,
  custom,
}

// Controleur simple pour le theme de l'app.
class ThemeController {
  final ValueNotifier<AppThemeSelection> selection =
      ValueNotifier<AppThemeSelection>(AppThemeSelection.system);

  // Met a jour le theme selectionne.
  void setSelection(AppThemeSelection nextSelection) {
    selection.value = nextSelection;
  }

  // Libere les ressources du controller.
  void dispose() {
    selection.dispose();
  }
}
