import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Settings View',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      // Add more widgets and functionality as needed
    );
  }
}
