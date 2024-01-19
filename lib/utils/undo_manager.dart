import 'package:archon/models/equipment.dart';

class UndoManager {
  final List<Equipment> historyStack = [];
  final int maxHistorySize;

  UndoManager({this.maxHistorySize = 10});

  void saveState(Equipment equipment) {
    historyStack.add(equipment.clone());
    if (historyStack.length > maxHistorySize) {
      historyStack.removeAt(0);
    }
  }

  Equipment? undo() {
    if (historyStack.isNotEmpty) {
      return historyStack.removeLast();
    }
    return null;
  }
}
