import 'package:flutter/material.dart' hide NavigationBar;
import 'src/ui/widgets/navigation_bar.dart';
import 'src/ui/pages/habits_page.dart';
import 'src/ui/pages/dailies_page.dart';
import 'src/ui/pages/setting_page.dart';

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
      // Remove the named routes that are not used by the main navigator
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    // Add a key for each tab
  ];

  void _onNavBarItemTapped(int index) {
    // Check if the selected index is the current index
    if (_selectedIndex == index) {
      // Pop to the first route if the user taps on the active tab
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (index) {
            case 0:
              builder = (BuildContext context) => HabitsPage();
              break;
            case 1:
              builder = (BuildContext context) => DailiesPage();
              break;
            // Add other cases for more pages
            default:
              builder = (BuildContext context) => Center(child: Text('Page Placeholder'));
              break;
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: List.generate(_navigatorKeys.length, (index) => _buildOffstageNavigator(index)),
      ),
      bottomNavigationBar: NavigationBar(
        currentIndex: _selectedIndex,
        onItemSelected: _onNavBarItemTapped,
      ),
      floatingActionButton: _selectedIndex == 1 // Assuming the FAB is only for the DailiesPage
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                // Here you can handle the FAB press based on the selected index
                _navigatorKeys[_selectedIndex].currentState?.push(
                  MaterialPageRoute(
                    builder: (context) => SettingsPage(),
                    // fullscreenDialog: true, // Remove this if you want to see the bottom navigation bar
                  ),
                );
              },
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
