import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/providers/app_state_provider.dart';
import 'package:i12_into_012/screens/todo_list_screen.dart';

void main() {
  // makes Riverpod available throughout the application.

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

/// Root widget of the todo application.
class MyApp extends ConsumerWidget {
  /// Creates the root widget of the todo application.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watches the current application state.
    final appState = ref.watch(appStateProvider);
    return MaterialApp(
      // Defines the appearance of the light theme.
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
      ),

      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),

      themeMode: (appState.value?.isDarkMode ?? false)
          ? ThemeMode.dark
          : ThemeMode.light,

      // Opens the todo list as the main screen.
      home: const TodoListScreen(),
    );
  }
}
