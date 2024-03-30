import 'package:flutter/material.dart' hide NavigationBar;
// import 'package:firebase_core/firebase_core.dart';
import 'src/ui/widgets/navigation_bar.dart';
import 'src/ui/pages/habits_page.dart'; // Import the HabitsPage
import 'src/ui/pages/dailies_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyberpunk Habitica',
      theme: ThemeData(
        // Define your app theme if needed
      ),
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

  // Use a function to lazily create the pages
  Widget _getPage(int index) {
    switch (index) {
      case 0:
        return HabitsPage();
      case 1:
        return DailiesPage();
      // Add other cases for more pages
      default:
        return Center(child: Text('Page Placeholder'));
    }
  }

  void _onNavBarItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getPage(_selectedIndex),
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