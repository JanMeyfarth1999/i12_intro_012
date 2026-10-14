import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/providers/app_state_provider.dart';
import 'package:i12_into_012/widgets/add_todo_dialog.dart';
import 'package:i12_into_012/widgets/todo_item.dart';

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
        // Shows the delete button only when at least one todo is selected.
        actions: [
          if (appState.selectedTodoIds.isNotEmpty)
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.delete),
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: appState.todos.length,
        itemBuilder: (context, index) {
          final todo = appState.todos[index];

          return TodoItem(
            key: ValueKey(todo.id),
            todo: todo,
            onToggle: () {
              // Toggles the completion status of this todo.
              ref.read(appStateProvider.notifier).toggleTodo(todo.id);
            },
            // chcks whether tis todo is currently selected.
            isSelected: appState.selectedTodoIds.contains(todo.id),

            // Selects or deselects this todo.
            onSelectionToggle: () {
              ref.read(appStateProvider.notifier).toggleTodoSelection(todo.id);
            },
          );
        },
      ),

      // Opens the dialog for creating a new todo.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return const AddTodoDialog();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
