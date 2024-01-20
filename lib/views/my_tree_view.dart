import 'package:archon/models/equipment.dart';
import 'package:archon/views/equipment_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';

class MyTreeView extends StatefulWidget {
  final Equipment equipmentTree;
  final Function(Equipment) onEquipmentSelected;

  const MyTreeView(
      {super.key,
      required this.equipmentTree,
      required this.onEquipmentSelected});

  @override
  MyTreeViewState createState() => MyTreeViewState();
}

class MyTreeViewState extends State<MyTreeView> {
  late final TreeController<MyTreeNode> treeController;
  late List<MyTreeNode> roots;

  @override
  void initState() {
    super.initState();

    roots = [_convertEquipmentToTreeNode(widget.equipmentTree)];

    treeController = TreeController<MyTreeNode>(
      roots: roots,
      childrenProvider: (MyTreeNode node) => node.children,
      parentProvider: (MyTreeNode node) => node.parent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TreeView<MyTreeNode>(
      treeController: treeController,
      nodeBuilder: (BuildContext context, TreeEntry<MyTreeNode> entry) {
        return TreeIndentation(
          entry: entry,
          // Optional: Use if you want to display connection lines

          child: Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    treeController.toggleExpansion(entry.node);
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Icon(
                    entry.node.isExpanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                    size: 20.0,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Equipment? selectedEquipment = findEquipmentByUUID(
                      widget.equipmentTree, entry.node.uuid);
                  if (selectedEquipment != null) {
                    widget.onEquipmentSelected(selectedEquipment);
                  }
                },
                child: Text(entry.node.title),
              ),
            ],
          ),
        );
      },
    );
  }

  Equipment? findEquipmentByUUID(Equipment root, String uuid) {
    if (root.uuid == uuid) return root;
    for (var child in root.children) {
      var found = findEquipmentByUUID(child, uuid);
      if (found != null) return found;
    }
    return null;
  }

  MyTreeNode _convertEquipmentToTreeNode(Equipment equipment,
      [MyTreeNode? parent]) {
    var childrenNodes = equipment.children
        .map((child) => _convertEquipmentToTreeNode(child, parent))
        .toList();

    return MyTreeNode(
      title: equipment.name,
      children: childrenNodes,
      parent: parent,
      uuid: equipment.uuid,
    );
  }
}
