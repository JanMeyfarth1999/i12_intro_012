import 'package:i12_into_012/models/app_state.dart';
import 'package:i12_into_012/models/todo.dart';
import 'package:i12_into_012/services/storage_interface.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseStorageService implements StorageInterface {
  Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'todos.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE todos (
            id TEXT PRIMARY KEY,
            text TEXT NOT NULL,
            isCompleted INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE todos (
           id INTEGER PRIMARY KEY,
           isDarkmode INTEGER NOT NULL,
           asksForDeletionConfirmation INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  @override
  Future<void> saveState(AppState state) async {
    final db = await _openDatabase();

    await db.transaction((txn) async {
      await txn.delete('todos');
      for (final todo in state.todos) {
        await txn.insert(
          'settings',
          {
            'id': 1,
            'isDarkMode': state.isDarkMode ? 1 : 0,
            'asksForDeletionConfirmation': state.asksForDeletionConfirmation
                ? 1
                : 0,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        await txn.insert(
          'todos',
          {
            'id': todo.id,
            'text': todo.text,
            'isCompleted': todo.isCompleted ? 1 : 0,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  @override
  Future<AppState?> loadState() async {
    final db = await _openDatabase();
    final rows = await db.query('todos');
    final settingsRows = await db.query('settings');
    var isDarkMode = false;
    var asksForDeletionConfirmation = true;
    if (settingsRows.isNotEmpty) {
      final settings = settingsRows.first;
      isDarkMode = settings['isDarkMode'] == 1;
      asksForDeletionConfirmation =
          settings['asksForDeletionConfirmation'] == 1;
    }
    final todos = rows.map((row) {
      return Todo(
        id: row['id']! as String,
        text: row['text']! as String,
        isCompleted: row['isCompleted'] == 1,
      );
    }).toList();
    return AppState(
      todos: todos,
      isDarkMode: isDarkMode,
      asksForDeletionConfirmation: asksForDeletionConfirmation,
    );
  }
}
