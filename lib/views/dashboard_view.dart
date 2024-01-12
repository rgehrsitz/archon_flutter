import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Dashboard View',
            style: Theme.of(context).textTheme.headlineMedium),
      ),
      // Add more widgets and functionality as needed
    );
  }
}
