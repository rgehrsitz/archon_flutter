import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'equipment.dart';
import '../utils/undo_manager.dart';

final undoManagerProvider = Provider<UndoManager>((ref) {
  return UndoManager();
});

final equipmentProvider = StateProvider<Equipment?>((ref) => null);
final currentFilePathProvider = StateProvider<String?>((ref) => null);
