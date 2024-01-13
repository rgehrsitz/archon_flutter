import 'package:flutter/material.dart';
import 'package:archon/views/dashboard_view.dart';
import 'package:archon/views/equipment_view.dart';
import 'package:archon/views/git_view.dart';
import 'package:archon/views/settings_view.dart';

void main() {
  runApp(const MyApp());
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellowAccent),
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
      appBar: AppBar(
        title: const Text('Archon'),
        actions: [
          IconButton(
            icon: const Icon(Icons.manage_accounts),
            tooltip: 'Accounts',
            onPressed: () {},
          )
        ],
        // Add other app bar properties or actions
      ),
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
