import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/providers/app_state_provider.dart';

/// Dialog for entering a new todo.
class AddTodoDialog extends ConsumerStatefulWidget {
  const AddTodoDialog({super.key});

  @override
  ConsumerState<AddTodoDialog> createState() => _AddTodoDialogState();
} 

class _AddTodoDialogState extends ConsumerState<AddTodoDialog> {
  // Controls and reads the text entered for a new todo.
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    // Releases the controller when the dialog is closed.
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Neues Todo'),
      // Input field for the todo text.
      content: TextField(
        controller: _textController,
        autofocus: true,
        decoration: const InputDecoration(
          labelText: 'Todo',
          hintText: 'Was möchtest du erledigen ?',
        ),
      ),
      actions: [
        // Closes the dialog without adding a todo.
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Abbrechen'),
        ),
        // Adds the entered todo and closes the dialog.
        TextButton(
          onPressed: () async {
            final text = _textController.text.trim();

            if (text.isNotEmpty) {
              await ref.read(appStateProvider.notifier).addTodo(text);

              if (context.mounted) {
                Navigator.of(context).pop();
              }
            }
          },
          child: const Text('Hinzufügen'),
          )
      ],
    );
  }
}


