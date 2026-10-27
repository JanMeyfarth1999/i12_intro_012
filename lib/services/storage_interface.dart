import 'package:i12_into_012/models/app_state.dart';

abstract class StorageInterface {
  Future<void> saveState(AppState state);

  Future<AppState?> loadState();
}
