import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/models/app_state.dart';
import 'package:i12_into_012/models/todo.dart';
import 'package:i12_into_012/providers/app_state_notifier_interface.dart';
import 'package:i12_into_012/services/database_storage_service.dart';
import 'package:i12_into_012/services/storage_interface.dart';
import 'package:i12_into_012/services/storage_service.dart';
import 'package:uuid/uuid.dart';

/// Manages the application state and its changes.
abstract class BaseAppStateNotifier extends AsyncNotifier<AppState>
    implements AppStateNotifierInterface {
  StorageInterface get storageService;

  /// Generates a unique ID for every new todo.
  final Uuid _uuid = const Uuid();

  /// Loads the saved application state when the notifier starts.
  @override
  Future<AppState> build() async {
    // Gets the storage service of the selected notifier.
    final storageService = this.storageService;

    // Loads the saved data from JSON or SQLite.
    final savedState = await storageService.loadState();

    // Returns the saved data or an empty initial state.
    return savedState ?? const AppState();
  }

  /// Adds a new todo to the application state.
  @override
  Future<void> addTodo(String text) async {
    // Waits until the application state is available.
    final currentState = await future;

    // Creates a new todo with a unique ID.
    final newTodo = Todo(
      id: _uuid.v4(),
      text: text,
    );

    // Creates an updated application state.
    final updatedState = currentState.copyWith(
      todos: [...currentState.todos, newTodo],
    );

    // Saves the new todo.
    await storageService.insertTodo(newTodo);

    // Publishes the updated state.
    state = AsyncData(updatedState);
  }

  /// Toggles the completion status of a todo.
  @override
  Future<void> toggleTodo(String id) async {
    // Waits until the application state is available.
    final currentState = await future;

    // Finds the todo that should be updated.
    final index = currentState.todos.indexWhere(
      (todo) => todo.id == id,
    );

    // Stops if the todo does not exist.
    if (index == -1) {
      return;
    }

    // Creates a copy with the opposite completion status.
    final updatedTodo = currentState.todos[index].copyWith(
      isCompleted: !currentState.todos[index].isCompleted,
    );

    // Replaces the changed todo in a new list.
    final updatedTodos = [...currentState.todos];
    updatedTodos[index] = updatedTodo;

    // Saves only the changed todo.
    await storageService.updateTodo(updatedTodo);

    // Publishes the updated application state.
    state = AsyncData(
      currentState.copyWith(todos: updatedTodos),
    );
  }

  /// Selects or deselects a todo.
  @override
  void toggleTodoSelection(String id) {
    // Gets the current state if loading has finished.
    final currentState = state.value;

    // Stops if the state is not available yet.
    if (currentState == null) {
      return;
    }

    // Creates a copy of the selected todo IDs.
    final selectedIds = {...currentState.selectedTodoIds};

    // Removes an already selected ID or adds a new one.
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }

    // Publishes the updated state.
    state = AsyncData(
      currentState.copyWith(
        selectedTodoIds: selectedIds,
      ),
    );
  }

  /// Deletes all selected todos.
  @override
  Future<void> deleteTodos() async {
    // Waits until the application state is available.
    final currentState = await future;

    // Copies the IDs of the selected todos.
    final idsToDelete = {...currentState.selectedTodoIds};

    // Stops if no todos are selected.
    if (idsToDelete.isEmpty) {
      return;
    }

    // Creates a list without the selected todos.
    final updatedTodos = currentState.todos.where((todo) {
      return !idsToDelete.contains(todo.id);
    }).toList();

    // Deletes the selected todos from storage.
    for (final id in idsToDelete) {
      await storageService.deleteTodo(id);
    }

    // Publishes the updated state and clears the selection.
    state = AsyncData(
      currentState.copyWith(
        todos: updatedTodos,
        selectedTodoIds: {},
      ),
    );
  }

  /// Toggles between light mode and dark mode.
  @override
  Future<void> toggleDarkMode() async {
    // Waits until the application state is available.
    final currentState = await future;

    // Creates a new state with the opposite theme setting.
    final updatedState = currentState.copyWith(
      isDarkMode: !currentState.isDarkMode,
    );

    // Saves only the settings.
    await storageService.saveSettings(updatedState);

    // Publishes the updated state.
    state = AsyncData(updatedState);
  }

  /// Toggles the deletion confirmation setting.
  @override
  Future<void> toggleDeletionConfirmation() async {
    // Waits until the application state is available.
    final currentState = await future;

    // Creates a state with the opposite setting.
    final updatedState = currentState.copyWith(
      asksForDeletionConfirmation: !currentState.asksForDeletionConfirmation,
    );

    // Saves the updated settings.
    await storageService.saveSettings(updatedState);

    // Publishes the updated state.
    state = AsyncData(updatedState);
  }
}

/// Notifier for JSON storage.
class JsonAppStateNotifier extends BaseAppStateNotifier {
  final StorageInterface _storageService = StorageService();

  @override
  StorageInterface get storageService => _storageService;
}

/// Notifier for SQLite storage.
class SqliteAppStateNotifier extends BaseAppStateNotifier {
  // Creates one storage service instance for this notifier.
  final StorageInterface _storageService = DatabaseStorageService();

  // Returns the existing storage service instance.
  @override
  StorageInterface get storageService => _storageService;
}

/// Provides the selected asynchronous notifier.
final appStateProvider = AsyncNotifierProvider<BaseAppStateNotifier, AppState>(
  JsonAppStateNotifier.new,
);

/// Provides access to the notifier through its interface.
final appStateActionsProvider = Provider<AppStateNotifierInterface>((ref) {
  return ref.read(appStateProvider.notifier);
});
