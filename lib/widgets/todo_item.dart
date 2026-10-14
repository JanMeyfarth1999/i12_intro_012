import 'package:flutter/material.dart';
import 'package:i12_into_012/models/todo.dart';

/// Displays a single todo item.
class TodoItem extends StatelessWidget {
  final Todo todo;

  // Funktion that is called when the todo is toggled.
  final VoidCallback onToggle;

  // Inicates whether this todo is selected.
  final bool isSelected;

  // Function that is called when the todo selection changes.
  final VoidCallback onSelectionToggle;

  const TodoItem({
    required this.todo,
    required this.onToggle,
    required this.isSelected,
    required this.onSelectionToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // Shows whether the todo is completed.
      leading: Checkbox(
        value: todo.isCompleted,
        onChanged: (_) {
          onToggle();
        },
      ),
      title: Text(
        todo.text,
        style: TextStyle(
          // Crosses out the text when the todo is completed.
          decoration: todo.isCompleted
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),

      // Selects or deselects the todo when it is tapped.
      onTap: onSelectionToggle,

      // Highlights the todo when it is selected.
      selected: isSelected,
    );
  }
}
