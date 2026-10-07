import 'dart:convert';
import 'dart:io';

import 'package:i12_into_012/models/app_state.dart';
import 'package:path_provider/path_provider.dart';

/// Handles saving and loading the application state.
class StorageService {
  // Returns the file used to store the application state.
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/todo_app_state.json');
  }
  /// Saves the current application state to the JSON file.
  Future<void> saveSate(AppState state) async {
      final file = await _getFile();

      /// Converts the AppState into a JSON string.
      final jsonString = jsonEncode(state.toJson());

      /// Writes the JSON string to the file.
      await file.writeAsString(jsonString);
    }

    ///Loads the application state from the JSON file.
    Future<AppState?> loadState() async {
      final file = await _getFile();
      // Returns null if no saved state exists yet.
      if(!await file.exists()) {
        return null;
      }
      //Reads the saved JSON string from the file. 
      final jsonString = await file.readAsString();

      // Converts the JSON string back into a Map.
      final json = jsonDecode(jsonString) as Map<String,dynamic>;
      return AppState.fromJson(json);
    }
  
}
 
