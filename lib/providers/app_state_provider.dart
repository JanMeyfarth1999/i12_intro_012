
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:i12_into_012/models/app_state.dart';
import 'package:i12_into_012/services/storage_service.dart';

import 'package:i12_into_012/models/todo.dart';
import 'package:uuid/uuid.dart';

// Provides access to the local storage service.
final StorageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

/// Manages the application state and its changes.
class AppStateNotifier extends Notifier<AppState> {
  // Creates the initial state of the application
  @override
    // Generates a unique ID for every new todo.
  final Uuid _uuid = Uuid(); 
  AppState build() {
    loadState();
    return AppState();
  }
    // Loads the saved application state from local storage.
  Future<void> loadState()async {
    final StorageService = ref.read(StorageServiceProvider);
    final savedState = await StorageService.loadState();

    if(savedState != null) {
      state = savedState;
    }
  }

  

}
