import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:i12_into_012/models/todo.dart';

part 'app_state.freezed.dart';
part 'app_state.g.dart';

/// Represents the current state of the todo application.
@freezed
abstract class AppState with _$AppState {
  /// Creates a new AppState.
  const factory AppState({
    @Default([]) List<Todo> todos,
    @Default(false) bool isDarkMode,
    @Default(true) bool asksForDeletionConfirmation,
    @Default({}) Set<String> selectedTodoIds,
  }) = _AppState;

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);
}
