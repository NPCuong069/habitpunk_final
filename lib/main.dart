import 'package:flutter/material.dart' hide NavigationBar;
import 'package:habitpunk/src/ui/pages/party_page.dart';
import 'src/ui/widgets/navigation_bar.dart';
import 'src/ui/pages/habits_page.dart';
import 'src/ui/pages/dailies_page.dart';
import 'src/ui/pages/setting_page.dart';
import 'src/ui/pages/customization_page.dart';
import 'src/ui/widgets/add_sheets.dart';
import 'src/ui/widgets/status_bar.dart';
import 'src/ui/pages/login_page.dart';
import 'src/ui/pages/sign_up_page.dart';

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
     initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
      },
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
    GlobalKey<NavigatorState>(),
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

  AppBar _buildAppBar(BuildContext context, String title) {
      List<Widget> actions = _selectedIndex == 1
        ? [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {

              },
            ),
          ]
        : [];
    return AppBar(
      centerTitle: true,
      toolbarHeight: MediaQuery.of(context).size.height * 0.05,
      backgroundColor: Color.fromARGB(255, 5, 23, 37),
      title: Text(title,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.height * 0.025,
              color: Colors.white)),
      actions: actions,
    );
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
            case 2:
              builder = (BuildContext context) => CustomizationPage();
              break;
            case 3:
              builder = (BuildContext context) => PartyPage();
              break;
            case 4:
              builder = (BuildContext context) => SettingsPage();
              break;
            default:
              builder = (BuildContext context) =>
                  Center(child: Text('Page Placeholder'));
              break;
          }
          
          return MaterialPageRoute(builder: builder, settings: settings);
        },
      ),
    );
  }

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'Habits';
      case 1:
        return 'Dailies';
      case 2:
        return 'Customization';
      case 3:
        return 'Party';
      case 4:
        return 'Settings';
      default:
        return 'Cyberpunk Habitica';
    }
  }

  final ThemeData appTheme = ThemeData(
    scaffoldBackgroundColor: Color.fromARGB(255, 5, 23, 37),
    // Add other theme properties if needed.
  );
  @override
  Widget build(BuildContext context) {
    UserStatusCard userStatusCard = UserStatusCard(
      avatarUrl: 'https://via.placeholder.com/150',
      health: 44,
      maxHealth: 50,
      experience: 123,
      nextLevelExp: 330,
      mana: 54,
      maxMana: 58,
      level: 14,
      userClass: 'Bulwark',
    );
    bool shouldShowUserStatus =
        _selectedIndex == 0 || _selectedIndex == 1 || _selectedIndex == 2;

    return Theme(
      data: appTheme,
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 5, 23, 37),
        appBar: _buildAppBar(
            context,
            _getAppBarTitle(
                _selectedIndex)), // Use the _buildAppBar method here
        body: SafeArea(
          child: Column(
            children: <Widget>[
              // Show the UserStatusCard at the top of the selected pages
              if (shouldShowUserStatus)
                UserStatusCard(
                  avatarUrl: 'https://via.placeholder.com/150',
                  health: 44,
                  maxHealth: 50,
                  experience: 123,
                  nextLevelExp: 330,
                  mana: 54,
                  maxMana: 58,
                  level: 14,
                  userClass: 'Bulwark',
                ),
              Expanded(
                child: Stack(
                  children: List.generate(_navigatorKeys.length,
                      (index) => _buildOffstageNavigator(index)),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          currentIndex: _selectedIndex,
          onItemSelected: _onNavBarItemTapped,
        ),
        floatingActionButton: _selectedIndex == 1 // For Dailies Page
            ? FloatingActionButton(
                child: Icon(Icons.add, color: Colors.white),
                backgroundColor: Color.fromARGB(255, 14, 31, 46),
                onPressed: () => showAddDailySheet(
                    context), // Call the showAddDailySheet method
              )
            : _selectedIndex == 0 // For Habits Page
                ? FloatingActionButton(
                    child: Icon(Icons.add, color: Colors.white),
                    backgroundColor: Color.fromARGB(255, 14, 31, 46),
                    onPressed: () => showAddHabitSheet(
                        context), // Call the showAddHabitSheet method
                  )
                : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
