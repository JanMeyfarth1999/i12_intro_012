import 'package:i12_into_012/models/app_state.dart';
import 'package:i12_into_012/services/storage_interface.dart';

class DatabaseStorageService implements StorageInterface {
  @override
  Future<void> saveState(AppState state) async {}

  @override
  Future<AppState?> loadState() async {
    return null; // Return null or an actual AppState object if available.
  }
}
