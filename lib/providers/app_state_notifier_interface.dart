abstract class AppStateNotifierInterface {
  Future<void> addTodo(String text);
  Future<void> toggleTodo(String id);
  Future<void> deleteTodos();
  void toggleTodoSelection(String id);
  Future<void> toggleDarkMode();
  Future<void> toggleDeletionConfirmation();
}
