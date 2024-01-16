import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MenuModel {
  static List<MenuItem> getFileMenu() {
    return [
      MenuItem(
          label: 'New',
          onPressed: () {
            // Handle new file
          }),
      MenuItem(
          label: 'Open...',
          onPressed: () {
            // Handle open file
          }),
      MenuItem(
        label: 'Save',
        onPressed: () {
          // Handle save file
        },
        shortcut: const SingleActivator(LogicalKeyboardKey.keyS, control: true),
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

class MyMenuBar extends StatelessWidget {
  const MyMenuBar({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuBar(
      children: [
        SubmenuButton(
          menuChildren: MenuModel.getFileMenu()
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
      ],
    );
  }
}
