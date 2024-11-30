import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/home_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/progress_summary_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Body Measurement Tracker',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/home', // Set the initial route
      routes: {
        '/home': (context) => const HomeScreenWrapper(),
        '/profile': (context) => const ProfileScreen(),
        '/progress': (context) => const ProgressSummaryScreen(),
      },
    );
  }
}

class HomeScreenWrapper extends StatefulWidget {
  const HomeScreenWrapper({Key? key}) : super(key: key);

  @override
  _HomeScreenWrapperState createState() => _HomeScreenWrapperState();
}

class _HomeScreenWrapperState extends State<HomeScreenWrapper> {
  int _selectedIndex = 0; // Keeps track of the selected index
  final List<Widget> _screens = [
    const HomeScreen(),
    const ProfileScreen(),
    const ProgressSummaryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BodyCheck"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.green, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 28),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 28),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, size: 28),
            label: 'Progress',
          ),
        ],
        selectedItemColor: Colors.greenAccent,
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.white,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        type: BottomNavigationBarType.fixed,
        elevation: 15,
      ),
    );
  }
}
