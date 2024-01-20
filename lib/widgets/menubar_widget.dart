import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/file_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MenuModel {
  static List<MenuItem> getFileMenu(WidgetRef ref) {
    return [
      MenuItem(
          label: 'New',
          onPressed: () {
            // Handle new file
          }),
      MenuItem(
          label: 'Open...',
          onPressed: () async {
            // Handle open file
            await openFileDialog(ref);
          }),
      MenuItem(
        label: 'Save',
        onPressed: () {
          saveEquipment(ref);
        },
        shortcut: const SingleActivator(LogicalKeyboardKey.keyS, control: true),
      ),
      MenuItem(
        label: 'Save As',
        onPressed: () {
          saveEquipment(ref, saveAs: true);
        },
        shortcut: const SingleActivator(LogicalKeyboardKey.keyA, control: true),
      ),
      MenuItem(
          label: 'Exit',
          onPressed: () {
            // Handle exit
          }),
    ];
  }

  static List<MenuItem> getEditMenu() {
    return [
      MenuItem(
        label: 'Cut',
        onPressed: () {
          // Handle cut
        },
        shortcut: const SingleActivator(LogicalKeyboardKey.keyX, control: true),
      ),
      MenuItem(
        label: 'Copy',
        onPressed: () {
          // Handle copy
        },
        shortcut: const SingleActivator(LogicalKeyboardKey.keyC, control: true),
      ),
      MenuItem(
        label: 'Paste',
        onPressed: () {
          // Handle paste
        },
        shortcut: const SingleActivator(LogicalKeyboardKey.keyV, control: true),
      ),
    ];
  }
}

// Menu item class
class MenuItem {
  final String label;
  final VoidCallback onPressed;
  final MenuSerializableShortcut? shortcut;

  MenuItem({
    required this.label,
    required this.onPressed,
    this.shortcut,
  });
}

class MyMenuBar extends ConsumerWidget {
  const MyMenuBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MenuBar(
      children: [
        SubmenuButton(
          menuChildren: MenuModel.getFileMenu(ref)
              .map(
                (item) => MenuItemButton(
                  onPressed: item.onPressed,
                  child: Text(item.label),
                ),
              )
              .toList(),
          child: const Text('File'),
        ),
        SubmenuButton(
          menuChildren: MenuModel.getEditMenu()
              .map(
                (item) => MenuItemButton(
                  onPressed: item.onPressed,
                  child: Text(item.label),
                ),
              )
              .toList(),
          child: const Text('Edit'),
        ),
        // ... Other SubmenuButtons
      ],
    );
  }
}
