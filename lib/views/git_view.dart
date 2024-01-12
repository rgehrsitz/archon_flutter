import 'package:flutter/material.dart';

class GitView extends StatelessWidget {
  const GitView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            Text('Git View', style: Theme.of(context).textTheme.headlineMedium),
      ),
      // Add more widgets and functionality as needed
    );
  }
}
