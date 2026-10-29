import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo.freezed.dart';
part 'todo.g.dart';

/// Generates copyWith, toJson, Todo.fromJson, Operator ==, hashCode
@freezed
abstract class Todo with _$Todo {
  /// Creates a new Todo.
  const factory Todo({
    required String id,
    required String text,
    @Default(false) bool isCompleted,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
