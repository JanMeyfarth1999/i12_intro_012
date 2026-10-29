import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/models/app_state.dart';
import 'package:i12_into_012/models/todo.dart';
import 'package:i12_into_012/providers/app_state_notifier_interface.dart';
import 'package:i12_into_012/services/database_storage_service.dart';
import 'package:i12_into_012/services/storage_interface.dart';
import 'package:i12_into_012/services/storage_service.dart';
import 'package:uuid/uuid.dart';

/// Provides access to the local storage service.
const bool useSqlite = true;

final storageServiceProvider = Provider<StorageInterface>((ref) {
  return useSqlite ? DatabaseStorageService() : StorageService();
});

/// Manages the application state and its changes.
class AppStateNotifier extends Notifier<AppState>
    implements AppStateNotifierInterface {
  /// Generates a unique ID for every new todo.
  final Uuid _uuid = const Uuid();
  @override
  AppState build() {
    loadState();
    return const AppState();
  }

  /// Loads the saved application state from local storage.
  Future<void> loadState() async {
    final storageService = ref.read(storageServiceProvider);
    final savedState = await storageService.loadState();

    if (savedState != null) {
      state = savedState;
    }
  }

  /// Adds a new todo to the application state.
  @override
  Future<void> addTodo(String text) async {
    final newTodo = Todo(
      // Creates a new todo with a unique ID.
      id: _uuid.v4(),
      text: text,
    );
    // Creates a new state with the new todo added to the existing todos.
    state = state.copyWith(
      todos: [...state.todos, newTodo],
    );
    // Saves the updated state.
    final storageService = ref.read(storageServiceProvider);
    await storageService.insertTodo(newTodo);
  }

  // Toggles the completion status of a todo.
  @override
  Future<void> toggleTodo(String id) async {
    // creates a new list and toggles only the todo with the matching ID.
    Todo? updatedTodo;
    final updatedTodos = state.todos.map((todo) {
      if (todo.id == id) {
        updatedTodo = todo.copyWith(
          isCompleted: !todo.isCompleted,
        );
        return updatedTodo!;
      }
      return todo;
    }).toList();

    state = state.copyWith(
      todos: updatedTodos,
    );
    if (updatedTodo != null) {
      final storageService = ref.read(storageServiceProvider);
      await storageService.updateTodo(updatedTodo!);
    }
  }

  @override
  void toggleTodoSelection(String id) {
    // Creates a copy of the currently selected todo IDs.
    final selectedIds = {...state.selectedTodoIds};
    if (selectedIds.contains(id)) {
      // Removes the ID if the todo is already selected.
      selectedIds.remove(id);
    } else {
      // Adds the ID if the todo is not selected yet.
      selectedIds.add(id);
    }
    // Updates the state with the new selection.
    state = state.copyWith(
      selectedTodoIds: selectedIds,
    );
  }

  // Deletes all currently selected todos.
  @override
  Future<void> deleteTodos() async {
    final idsToDelete = {...state.selectedTodoIds};
    // Creates a new list without the selected todos.
    final updatedTodos = state.todos.where((todo) {
      return !state.selectedTodoIds.contains(todo.id);
    }).toList();
    // Updates the state an clears the selection.
    state = state.copyWith(
      todos: updatedTodos,
      selectedTodoIds: {},
    );
    final storageService = ref.read(storageServiceProvider);
    for (final id in idsToDelete) {
      await storageService.deleteTodo(id);
    }
  }

  //Toggles between light mode and dark mode.
  @override
  Future<void> toggleDarkMode() async {
    state = state.copyWith(
      isDarkMode: !state.isDarkMode,
    );
    // Saves the updated dark mode setting.
    final storageService = ref.read(storageServiceProvider);
    await storageService.saveSettings(state);
  }

  // Toggles the deletion confirmation setting.
  @override
  Future<void> toggleDeletionConfirmation() async {
    state = state.copyWith(
      asksForDeletionConfirmation: !state.asksForDeletionConfirmation,
    );
    // Saves the updated deletion confirmation setting.
    final storageService = ref.read(storageServiceProvider);
    await storageService.saveSettings(state);
  }
}

final appStateProvider = NotifierProvider<AppStateNotifier, AppState>(
  AppStateNotifier.new,
);
