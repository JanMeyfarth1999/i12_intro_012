import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/providers/app_state_provider.dart';

// Displas the application settings.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext completed, WidgetRef ref) {
    // Watches the current application state.
    final appState = ref.watch(appStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Einstellungen'),
      ),
      body: ListView(
        children: [
          // Enables or disables dark mode.
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: appState.isDarkMode,
            onChanged: (_) {
              ref.read(appStateActionsProvider).toggleDarkMode();
            },
          ),
          // Enables or disables deletion confirmation.
          SwitchListTile(
            title: const Text('Löschbestätigung'),
            value: appState.asksForDeletionConfirmation,
            onChanged: (_) {
              ref.read(appStateActionsProvider).toggleDeletionConfirmation();
            },
          ),
        ],
      ),
    );
  }
}
