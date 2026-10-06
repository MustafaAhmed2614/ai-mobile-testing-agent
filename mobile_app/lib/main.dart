import 'package:flutter/material.dart';

import 'screens/upload_screen.dart';
import 'screens/reports_screen.dart';

void main() {
  runApp(const AiMobileTestingApp());
}

class AiMobileTestingApp extends StatelessWidget {
  const AiMobileTestingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AI Mobile Testing Agent',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() =>
      _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int currentIndex = 0;

  final screens = const [
    UploadScreen(),
    ReportsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.upload_file),
            label: 'Analyze',
          ),
          NavigationDestination(
            icon: Icon(Icons.history),
            label: 'Reports',
          ),
        ],
      ),
    );
  }
}