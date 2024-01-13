import 'package:flutter/material.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 2 / 1,
        children: [
          _buildPanel(
            title: 'Equipment List',
            content: 'List of all equipment...',
            actionLabel: 'Manage',
            onAction: () {
              // Navigate to equipment management
            },
          ),
          _buildPanel(
            title: 'Project Overview',
            content: 'Overview of the current project...',
            actionLabel: 'View Details',
            onAction: () {
              // Navigate to project details
            },
          ),
          _buildPanel(
            title: 'Command Log',
            content: 'Recent commands will appear here...',
            actionLabel: 'Open Log',
            onAction: () {
              // Open command log
            },
          ),
          _buildPanel(
            title: 'Tools & Integrations',
            content: 'Quick access tools...',
            actionLabel: 'Configure',
            onAction: () {
              // Open tools/integrations settings
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPanel({
    required String title,
    required String content,
    required String actionLabel,
    required VoidCallback onAction,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Center(
                child: Text(content),
              ),
            ),
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}
