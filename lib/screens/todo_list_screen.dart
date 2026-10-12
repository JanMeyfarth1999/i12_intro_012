import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/providers/app_state_provider.dart';

// Display the list of todos.
class TodoListScreen extends ConsumerWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watches the current application state.
    final appState = ref.watch(appStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
      ),
      body: Center(
        child: Text(
          'Todos: ${appState.todos.length}',
        ),
      ),
    );
  }
}