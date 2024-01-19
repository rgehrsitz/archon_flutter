import 'package:flutter/material.dart';
import 'package:archon/views/dashboard_view.dart';
import 'package:archon/views/equipment_view.dart';
import 'package:archon/views/git_view.dart';
import 'package:archon/views/settings_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/menubar_widget.dart';

void main() {
  runApp(
    const ProviderScope(
      // Make sure to wrap your app with ProviderScope
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Archon',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Archon Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color:
                Colors.grey[200], // Adjust the color to match your app's theme
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0), // Add some padding if needed
            child: Row(
              children: [
                const MyMenuBar(), // Your menu bar here
                const Spacer(), // This will push the following widgets to either side of the Row
                Text(
                  'Archon',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(), // Another spacer
                IconButton(
                  icon: const Icon(Icons.manage_accounts),
                  tooltip: 'Accounts',
                  onPressed: () {
                    // Your onPressed function here
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Scaffold(
              body: Row(
                children: [
                  NavigationRail(
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (int index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    labelType: NavigationRailLabelType.none,
                    indicatorShape: const CircleBorder(eccentricity: 0.0),
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.dashboard),
                        label: Text('Dashboard'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.list),
                        label: Text('Equipment Listing'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.compare),
                        label: Text('Git View'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings),
                        label: Text('Settings'),
                      ),
                    ],
                  ),
                  const VerticalDivider(thickness: 1, width: 1),
                  Expanded(
                    child: _getDrawerItemWidget(_selectedIndex),
                  ),
                ],
              ),
              bottomNavigationBar: const BottomAppBar(
                child: SizedBox(
                  height: 30.0,
                  child: Center(
                    child: Text('Status Bar - Display Status Here'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Placeholder for the main content area
  Widget _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return const DashboardView();
      case 1:
        return const EquipmentView();
      case 2:
        return const GitView();
      case 3:
        return const SettingsView();
      // Add other cases for different views
      default:
        return const Center(
            child: Text('Select an item from the navigation panel'));
    }
  }
}
