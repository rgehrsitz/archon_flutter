import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'equipment.dart';
import '../utils/undo_manager.dart';
import 'dart:io';
import 'package:git/git.dart';

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

final gitDirProvider = FutureProvider<GitDir?>((ref) async {
  String? filePath = ref.watch(currentFilePathProvider);
  if (filePath == null) {
    return null;
  }
  Directory dir = Directory(filePath).parent;
  if (await GitDir.isGitDir(dir.path)) {
    return GitDir.fromExisting(dir.path);
  } else {
    return GitDir.init(dir.path);
  }
});

final tagListProvider = FutureProvider<List<String>>((ref) async {
  // Watch for the gitDirProvider and handle its AsyncValue
  var gitDirAsyncValue = ref.watch(gitDirProvider);

  // Handle different states of the AsyncValue
  return gitDirAsyncValue.when(
    data: (gitDir) async {
      if (gitDir != null) {
        var result = await gitDir.runCommand(['tag']);
        return result.stdout
            .toString()
            .split('\n')
            .where((tag) => tag.isNotEmpty)
            .toList();
      } else {
        return []; // Return an empty list if gitDir is null
      }
    },
    loading: () async => [], // Return an empty list while loading
    error: (e, st) async => [], // Return an empty list on error
  );
});

final selectedTagProvider = StateProvider<String?>((ref) => null);
