import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/models/app_state.dart';
import 'package:i12_into_012/services/storage_service.dart';
import 'package:i12_into_012/models/todo.dart';
import 'package:uuid/uuid.dart';

/// Provides access to the local storage service.
final StorageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

/// Manages the application state and its changes.
class AppStateNotifier extends Notifier<AppState> {
 

  /// Generates a unique ID for every new todo.
  final Uuid _uuid = Uuid();
  @override
  AppState build() {
    loadState();
    return AppState();
  }

  /// Loads the saved application state from local storage.
  Future<void> loadState() async {
    final StorageService = ref.read(StorageServiceProvider);
    final savedState = await StorageService.loadState();

    if (savedState != null) {
      state = savedState;
    }
  }
  /// Saves the current state to local storage.
  Future<void> _saveState() async {
    final StorageService = ref.read(StorageServiceProvider);
    await StorageService.saveSate(state);
  }

  /// Adds a new todo to the application state.
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
   await _saveState();
  }
  // Toggles the completion status of a todo.
  Future<void> toggleTodo(String id) async {

  }
}
