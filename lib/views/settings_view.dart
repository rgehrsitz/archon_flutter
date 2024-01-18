import 'package:flutter/material.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  // Example settings values, replace with your actual settings
  bool autoFetch = true;
  bool autoPrune = true;
  String defaultBranchName = 'main';
  String externalMergeTool = 'Beyond Compare';
  String externalDiffTool = 'Beyond Compare';
  String externalEditor = 'Visual Studio Code';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          SettingsGroup(
            title: 'General',
            children: [
              SwitchListTile(
                title: const Text('Auto-Fetch Interval'),
                value: autoFetch,
                onChanged: (bool value) {
                  setState(() {
                    autoFetch = value;
                  });
                },
              ),
              SwitchListTile(
                title: const Text('Auto-Prune'),
                value: autoPrune,
                onChanged: (bool value) {
                  setState(() {
                    autoPrune = value;
                  });
                },
              ),
              ListTile(
                title: const Text('Default Branch Name'),
                subtitle: Text(defaultBranchName),
                onTap: () {
                  // Implement branch name change logic
                },
              ),
              // ... Add more settings
            ],
          ),
          SettingsGroup(
            title: 'Integrations',
            children: [
              ListTile(
                title: const Text('External Merge Tool'),
                subtitle: Text(externalMergeTool),
                onTap: () {
                  // Implement merge tool change logic
                },
              ),
              ListTile(
                title: const Text('External Diff Tool'),
                subtitle: Text(externalDiffTool),
                onTap: () {
                  // Implement diff tool change logic
                },
              ),
              ListTile(
                title: const Text('External Editor'),
                subtitle: Text(externalEditor),
                onTap: () {
                  // Implement editor change logic
                },
              ),
              // ... Add more integrations settings
            ],
          ),
          // ... Add more settings groups as necessary
        ],
      ),
    );
  }
}

class SettingsGroup extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const SettingsGroup({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}
