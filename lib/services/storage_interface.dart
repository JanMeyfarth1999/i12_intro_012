import 'package:i12_into_012/models/app_state.dart';
import 'package:i12_into_012/models/todo.dart';

abstract class StorageInterface {
  Future<void> saveState(AppState state);
  Future<AppState?> loadState();
  Future<void> insertTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<void> deleteTodo(String id);
  Future<void> saveSettings(AppState state);
}
