import 'dart:ffi' as ffi;

import 'package:flutter/material.dart';

import '../../core/bridge.dart';
import '../../options/definitions/options_catalog.dart';
import '../../options/options.dart';
import '../theme/theme_controller.dart';

class SettingsPage extends StatefulWidget {
  final ThemeController themeController;

  const SettingsPage({super.key, required this.themeController});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // UI spacing constants.
  static const double _pagePadding = 16.0;
  static const double _itemSpacing = 12.0;
  static const double _fieldSpacing = 8.0;
  static const double _fieldVerticalPadding = 6.0;

  final MXMLBridge _bridge = MXMLBridge();
  ffi.Pointer<MXMLOptions>? _options;
  bool _optionsReady = false;
  String _statusMessage = "Loading options...";

  final Map<String, bool> _boolValues = {};
  final Map<String, int> _intValues = {};
  final Map<String, double> _doubleValues = {};
  final Map<String, String> _stringValues = {};
  final Map<String, String> _stringListValues = {};
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, String> _previousTextValues = {};

  late final List<OptionSection> _optionSections = buildOptionSections(_bridge);

  // Acces rapide au controleur de theme.
  ThemeController get _themeController => widget.themeController;

  @override
  void initState() {
    super.initState();
    // Initialize the options bridge and load current values.
    try {
      MXMLBridge.initialize();
      _options = _bridge.optionsCreate();
      _bridge.optionsApplyStandard(_options!);
      _reloadOptionsFromBridge();
      _optionsReady = true;
      _statusMessage = "Options ready";
    } catch (e) {
      setState(() {
        _statusMessage = "Error initializing options: $e";
      });
    }
  }

  @override
  void dispose() {
    // Dispose FFI resources.
    if (_options != null) {
      _bridge.optionsDestroy(_options!);
    }
    // Dispose text controllers.
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const Tab(text: "Preferences"),
      ..._optionSections.map((section) => Tab(text: section.name)),
    ];
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
          bottom: TabBar(
            isScrollable: true,
            tabs: tabs,
          ),
        ),
        body: TabBarView(
          children: [
            _buildPreferencesView(),
            ..._optionSections.map((section) => _buildSectionView(section)),
          ],
        ),
      ),
    );
  }

  // Build the preferences view with theme selection.
  Widget _buildPreferencesView() {
    return ListView(
      padding: const EdgeInsets.all(_pagePadding),
      children: [
        Text("Theme", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: _itemSpacing),
        ValueListenableBuilder<AppThemeSelection>(
          valueListenable: _themeController.selection,
          builder: (context, selection, _) {
            return Column(
              children: [
                RadioListTile<AppThemeSelection>(
                  title: const Text("System"),
                  value: AppThemeSelection.system,
                  groupValue: selection,
                  onChanged: _updateThemeMode,
                ),
                RadioListTile<AppThemeSelection>(
                  title: const Text("Light"),
                  value: AppThemeSelection.light,
                  groupValue: selection,
                  onChanged: _updateThemeMode,
                ),
                RadioListTile<AppThemeSelection>(
                  title: const Text("Dark"),
                  value: AppThemeSelection.dark,
                  groupValue: selection,
                  onChanged: _updateThemeMode,
                ),
                RadioListTile<AppThemeSelection>(
                  title: const Text("Custom"),
                  value: AppThemeSelection.custom,
                  groupValue: selection,
                  onChanged: _updateThemeMode,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // Met a jour le theme depuis la selection UI.
  void _updateThemeMode(AppThemeSelection? selection) {
    // Ignore les valeurs nulles.
    if (selection == null) return;
    _themeController.setSelection(selection);
  }

  // Build a single section view for the tabs.
  Widget _buildSectionView(OptionSection section) {
    // Show loading while options are not ready.
    if (!_optionsReady) {
      return Center(child: Text(_statusMessage));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(_pagePadding),
      itemCount: section.items.length,
      itemBuilder: (context, index) {
        final item = section.items[index];
        return _buildOptionItem(item);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: _itemSpacing);
      },
    );
  }

  // Build a single option row based on its type.
  Widget _buildOptionItem(OptionItem item) {
    // Choose the UI widget based on the option type.
    switch (item.type) {
      case OptionValueType.boolean:
        final value = _boolValues[item.key] ?? false;
        return SwitchListTile(
          title: Text(item.label),
          value: value,
          onChanged: (nextValue) {
            _commitBoolOption(item, nextValue);
          },
        );
      case OptionValueType.integer:
      case OptionValueType.decimal:
      case OptionValueType.text:
      case OptionValueType.textList:
        return _buildTextOptionItem(item);
    }
  }

  // Build a text-based option row with a text field.
  Widget _buildTextOptionItem(OptionItem item) {
    final currentValue = _getTextValue(item);
    final controller = _getOrCreateController(item.key, currentValue);
    final keyboardType = _resolveKeyboardType(item.type);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(item.label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: _fieldSpacing),
        Focus(
          onFocusChange: (hasFocus) {
            // Commit on focus loss to keep UI and backend in sync.
            if (!hasFocus) {
              _commitTextOption(item, controller.text);
            }
          },
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: item.hint,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: _fieldSpacing,
                vertical: _fieldVerticalPadding,
              ),
            ),
            onSubmitted: (value) {
              _commitTextOption(item, value);
            },
          ),
        ),
      ],
    );
  }

  // Resolve the keyboard type for text inputs.
  TextInputType _resolveKeyboardType(OptionValueType type) {
    // Map numeric types to numeric keyboards.
    if (type == OptionValueType.integer) {
      return const TextInputType.numberWithOptions(decimal: false);
    }
    if (type == OptionValueType.decimal) {
      return const TextInputType.numberWithOptions(decimal: true);
    }
    return TextInputType.text;
  }

  // Refresh the local cache from the bridge.
  void _reloadOptionsFromBridge() {
    // Abort if options are not ready yet.
    if (_options == null) return;
    // Walk every section and item to refresh local state.
    for (final section in _optionSections) {
      for (final item in section.items) {
        // Read values based on the declared type.
        switch (item.type) {
          case OptionValueType.boolean:
            final value = item.boolGetter!(_options!);
            _boolValues[item.key] = value;
            break;
          case OptionValueType.integer:
            final value = item.intGetter!(_options!);
            _intValues[item.key] = value;
            _setControllerText(item.key, value.toString());
            break;
          case OptionValueType.decimal:
            final value = item.doubleGetter!(_options!);
            _doubleValues[item.key] = value;
            _setControllerText(item.key, value.toString());
            break;
          case OptionValueType.text:
            final value = item.stringGetter!(_options!);
            _stringValues[item.key] = value;
            _setControllerText(item.key, value);
            break;
          case OptionValueType.textList:
            final value = item.stringListGetter!(_options!).join(", ");
            _stringListValues[item.key] = value;
            _setControllerText(item.key, value);
            break;
        }
      }
    }
  }

  // Commit a boolean option change.
  void _commitBoolOption(OptionItem item, bool value) {
    // Skip if options are not ready.
    if (_options == null) return;
    setState(() {
      _boolValues[item.key] = value;
      item.boolSetter!(_options!, value);
    });
  }

  // Commit a text option based on its declared type.
  void _commitTextOption(OptionItem item, String text) {
    // Route to the right handler based on type.
    switch (item.type) {
      case OptionValueType.integer:
        _commitNumberOption(item, text, isInt: true);
        break;
      case OptionValueType.decimal:
        _commitNumberOption(item, text, isInt: false);
        break;
      case OptionValueType.text:
        _commitStringOption(item, text);
        break;
      case OptionValueType.textList:
        _commitStringListOption(item, text);
        break;
      case OptionValueType.boolean:
        break;
    }
  }

  // Commit a numeric option, with validation.
  void _commitNumberOption(OptionItem item, String text, {required bool isInt}) {
    // Skip if options are not ready.
    if (_options == null) return;
    final trimmed = text.trim();
    final previous = _previousTextValues[item.key] ?? "";
    // Restore previous when the input is empty.
    if (trimmed.isEmpty) {
      _setControllerText(item.key, previous);
      return;
    }
    // Parse input based on integer/decimal type.
    if (isInt) {
      final parsed = int.tryParse(trimmed);
      // Restore on invalid integer input.
      if (parsed == null) {
        _setControllerText(item.key, previous);
        return;
      }
      setState(() {
        _intValues[item.key] = parsed;
        _previousTextValues[item.key] = trimmed;
        item.intSetter!(_options!, parsed);
      });
      return;
    }
    final parsed = double.tryParse(trimmed);
    // Restore on invalid decimal input.
    if (parsed == null) {
      _setControllerText(item.key, previous);
      return;
    }
    setState(() {
      _doubleValues[item.key] = parsed;
      _previousTextValues[item.key] = trimmed;
      item.doubleSetter!(_options!, parsed);
    });
  }

  // Commit a plain string option.
  void _commitStringOption(OptionItem item, String text) {
    // Skip if options are not ready.
    if (_options == null) return;
    final trimmed = text.trim();
    setState(() {
      _stringValues[item.key] = trimmed;
      _previousTextValues[item.key] = trimmed;
      item.stringSetter!(_options!, trimmed);
    });
  }

  // Commit a list string option.
  void _commitStringListOption(OptionItem item, String text) {
    // Skip if options are not ready.
    if (_options == null) return;
    final trimmed = text.trim();
    final list = trimmed.isEmpty ? <String>[] : _parseStringList(trimmed);
    setState(() {
      _stringListValues[item.key] = trimmed;
      _previousTextValues[item.key] = trimmed;
      item.stringListSetter!(_options!, list);
    });
  }

  // Parse a comma-separated list of strings.
  List<String> _parseStringList(String text) {
    final parts = text.split(",");
    final output = <String>[];
    // Trim parts and skip empty entries.
    for (final part in parts) {
      final trimmed = part.trim();
      // Only keep non-empty parts.
      if (trimmed.isNotEmpty) {
        output.add(trimmed);
      }
    }
    return output;
  }

  // Get or create a text controller for an option key.
  TextEditingController _getOrCreateController(String key, String value) {
    final existing = _textControllers[key];
    // Reuse existing controller when available.
    if (existing != null) {
      return existing;
    }
    final controller = TextEditingController(text: value);
    _textControllers[key] = controller;
    _previousTextValues[key] = value;
    return controller;
  }

  // Update controller text without recreating the controller.
  void _setControllerText(String key, String value) {
    final controller = _textControllers[key];
    // Update only when the controller exists.
    if (controller != null) {
      controller.text = value;
    }
    _previousTextValues[key] = value;
  }

  // Read the current text value for an option item.
  String _getTextValue(OptionItem item) {
    // Choose source map based on the item type.
    switch (item.type) {
      case OptionValueType.integer:
        return _intValues[item.key]?.toString() ?? "";
      case OptionValueType.decimal:
        return _doubleValues[item.key]?.toString() ?? "";
      case OptionValueType.text:
        return _stringValues[item.key] ?? "";
      case OptionValueType.textList:
        return _stringListValues[item.key] ?? "";
      case OptionValueType.boolean:
        return "";
    }
  }
}
