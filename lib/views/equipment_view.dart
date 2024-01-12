import 'package:flutter/material.dart';

class EquipmentView extends StatelessWidget {
  const EquipmentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Equipment View',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      // Add more widgets and functionality as needed
    );
  }
}
