import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'equipment.dart';
import '../utils/undo_manager.dart';

final undoManagerProvider = Provider<UndoManager>((ref) {
  return UndoManager();
});

final currentFilePathProvider = StateProvider<String?>((ref) => null);

final equipmentProvider = StateNotifierProvider<EquipmentNotifier, Equipment?>(
    (ref) => EquipmentNotifier());

class EquipmentNotifier extends StateNotifier<Equipment?> {
  EquipmentNotifier() : super(null);

  void updateEquipment(Equipment updatedEquipment) {
    state = updatedEquipment;
  }
}
