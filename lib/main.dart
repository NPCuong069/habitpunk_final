import 'package:flutter/material.dart' hide NavigationBar;
import 'package:firebase_core/firebase_core.dart';
import 'src/ui/widgets/navigation_bar.dart';
import 'src/ui/pages/habits_page.dart'; // Import the HabitsPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyberpunk Habitica',
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Define the list of pages here
  final List<Widget> _pages = [
    HabitsPage(), // The HabitsPage is at index 0
    // Add other pages here at index 1, 2, and so on...
    Center(child: Text('Page 1 Placeholder')),
    Center(child: Text('Page 2 Placeholder')),
    Center(child: Text('Page 3 Placeholder')),
  ];

  void _onNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        currentIndex: _selectedIndex,
        onItemSelected: _onNavBarItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Add onPressed logic for FAB here
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
