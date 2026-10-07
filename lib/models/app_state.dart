import 'package:flutter/foundation.dart';
import 'todo.dart';

/// Represents the current state of the todo application.
@immutable
class AppState {
  final List<Todo> todos;
  final bool isDarkMode;
  final bool asksForDeletionConfirmation;
  final Set<String> selectedTodoIds;

  /// Creates a new AppState.
  AppState({
    this.todos = const [],
    this.isDarkMode = false,
    this.asksForDeletionConfirmation = true,
    this.selectedTodoIds = const {},
  });

  /// Create a copy with modified properties
  AppState copyWith({
    List<Todo>? todos,
    bool? isDarkMode,
    bool? asksForDeletionConfirmation,
    Set<String>? selectedTodoIds,
  }) {
    return AppState(
      todos: todos ?? this.todos,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      asksForDeletionConfirmation:
          asksForDeletionConfirmation ?? this.asksForDeletionConfirmation,
      selectedTodoIds: selectedTodoIds ?? this.selectedTodoIds,
    );
  }

  /// Converts this AppState into JSON data.
  Map<String, dynamic> toJson() {
    return {
      'todos': todos.map((todo) => todo.toJson()).toList(),
      'isDarkMode': isDarkMode,
      'asksForDeletionConfirmation': asksForDeletionConfirmation,
    };
  }
  /// Creates an AppState from JSON data.
factory AppState.fromJson(Map<String, dynamic> json) {
    return AppState(
    todos: (json['todos'] as List<dynamic>)
      .map((todoJson) => Todo.fromJson(todoJson as Map<String, dynamic>))
      .toList(),
    
    isDarkMode: json['isDarkMode'] as bool,
    asksForDeletionConfirmation: json['asksForDeletionConfirmation'] as bool,
    );


  }
  /// Compares two AppState objects by their values.
    @override
  bool operator ==(Object other) {
    return other is AppState && 
    listEquals(other.todos, todos) &&
    other.isDarkMode == isDarkMode &&
    other.asksForDeletionConfirmation == asksForDeletionConfirmation &&
    setEquals(other.selectedTodoIds, selectedTodoIds);
  }

    @override
  int get hashCode {
    return Object.hash(Object.hashAll(todos), isDarkMode, asksForDeletionConfirmation, Object.hashAllUnordered(selectedTodoIds),);
  }

}
