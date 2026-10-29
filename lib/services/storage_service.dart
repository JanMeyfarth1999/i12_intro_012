import 'dart:convert';
import 'dart:io';

import 'package:i12_into_012/models/app_state.dart';
import 'package:i12_into_012/models/todo.dart';
import 'package:i12_into_012/services/storage_interface.dart';
import 'package:path_provider/path_provider.dart';

/// Handles saving and loading the application state.
class StorageService implements StorageInterface {
  // Returns the file used to store the application state.
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/todo_app_state.json');
  }

  /// Saves the current application state to the JSON file.
  @override
  Future<void> saveState(AppState state) async {
    final file = await _getFile();

    /// Converts the AppState into a JSON string.
    final jsonString = jsonEncode(state.toJson());

    /// Writes the JSON string to the file.
    await file.writeAsString(jsonString);
  }

  ///Loads the application state from the JSON file.
  @override
  Future<AppState?> loadState() async {
    final file = await _getFile();
    // Returns null if no saved state exists yet.
    if (!await file.exists()) {
      return null;
    }
    //Reads the saved JSON string from the file.
    final jsonString = await file.readAsString();

    // Converts the JSON string back into a Map.
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return AppState.fromJson(json);
  }

  /// Adds a new todo to the JSON storage.
  @override
  Future<void> insertTodo(Todo todo) async {
    // Loads the previously saved state.
    final savedState = await loadState() ?? const AppState();

    // Creates a new state containing the additional todo.
    final updatedState = savedState.copyWith(
      todos: [...savedState.todos, todo],
    );

    // Saves the complete updatetd state
    await saveState(updatedState);
  }

  // Updates an existing todo in JSON storage.
  @override
  Future<void> updateTodo(Todo todo) async {
    //Loads the saved application state.
    final savedState = await loadState() ?? const AppState();

    // Replaces only the todo with the matching ID.
    final updatedTodos = savedState.todos.map((existingTodo) {
      if (existingTodo.id == todo.id) {
        return todo;
      }
      return existingTodo;
    }).toList();

    // Creates a new state with the updated todos.
    final updatedState = savedState.copyWith(
      todos: updatedTodos,
    );

    // Saves the complete JSON file.
    await saveState(updatedState);
  }

  /// Deletes a todo from JSON storage.
  @override
  Future<void> deleteTodo(String id) async {
    // Loads the saved applications state.
    final savedState = await loadState() ?? const AppState();

    // Keeps all todos except the one with the matching ID.
    final updatedTodos = savedState.todos.where((todo) {
      return todo.id != id;
    }).toList();

    //Creates a new state with the remaining todos.
    final updatedState = savedState.copyWith(
      todos: updatedTodos,
    );

    // Saves the updated JSON file.
    await saveState(updatedState);
  }

  @override
  Future<void> saveSettings(AppState state) async {
    // Load the existing state.
    final savedState = await loadState() ?? const AppState();

    // Keep the todos and update only the settings.
    final updatedState = savedState.copyWith(
      isDarkMode: state.isDarkMode,
      asksForDeletionConfirmation: state.asksForDeletionConfirmation,
    );

    // Save the updated JSON file.
    await saveState(updatedState);
  }
}
