import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide NavigationBar;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habitpunk/src/config/config.dart';
import 'package:habitpunk/src/riverpod/userHasParty_provider.dart';
import 'package:habitpunk/src/riverpod/user_provider.dart';
import 'package:habitpunk/src/services/notification_service.dart';
import 'package:habitpunk/src/services/notification_service.dart';
import 'package:habitpunk/src/ui/pages/noparty_page.dart';
import 'package:habitpunk/src/ui/pages/party_page.dart';
import 'package:habitpunk/src/ui/services/auth_state.dart';
import 'package:habitpunk/src/riverpod/daily_provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'src/ui/widgets/navigation_bar.dart';
import 'src/ui/pages/habits_page.dart';
import 'src/ui/pages/dailies_page.dart';
import 'src/ui/pages/setting_page.dart';
import 'src/ui/pages/customization_page.dart';
import 'src/ui/widgets/add_sheets.dart';
import 'src/ui/widgets/status_bar.dart';
import 'src/ui/pages/login_page.dart';
import 'src/ui/pages/sign_up_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:audioplayers/audioplayers.dart';

final FlutterSecureStorage secureStorage = FlutterSecureStorage();
void main() async {
  // Set environment based on the platform
  if (kIsWeb) {
    APIConfig.setEnvironment(Environment.WEB);
  } else if (Platform.isAndroid) {
    APIConfig.setEnvironment(Environment.ANDROID);
  } else if (Platform.isIOS) {
    APIConfig.setEnvironment(Environment.IOS);
  } else {
    // Default to local if the platform is not web, Android, or iOS
    APIConfig.setEnvironment(Environment.LOCAL);
  }
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.web,
  );
  if (Platform.isAndroid) {
    // Activate Play Integrity for Android
    await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity,
    );
  } else {
    // Optional: Handle other platforms if necessary
    await FirebaseAppCheck.instance.activate();
  }

  NotificationService().initialize();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyberpunk Habitica',
      theme: ThemeData(
          // Define your app theme if needed
          ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
      },
    );
  }
}

class MainScreen extends ConsumerStatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;
  bool _isSearching = false;
  bool userHasParty = false;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<GlobalKey<NavigatorState>> _navigatorKeys = [
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    GlobalKey<NavigatorState>(),
    // Add a key for each tab
  ];

  @override
  void initState() {
    super.initState();
    playMusic();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final container = ProviderScope.containerOf(context);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAndUpdatePartyStatus();
    });
  }

  void playMusic() async {
    await _audioPlayer.play(AssetSource('audio/Habitpunk main menu OST.mp3'), volume: 0.5);
    // Or use the following if you have your file in the assets folder
    // await _audioPlayer.play(AssetSource('assets/audio/your_music.mp3'), volume: 0.5);
  }

  void checkAndUpdatePartyStatus() {
    // Check the user's party status
    final user = ref.read(userProvider);
    setState(() {
      userHasParty = user?.partyId != null;
    });
  }

  void _onNavBarItemTapped(int index) {
    if (index == 3) {
      // Assuming index 3 is the party tab
      ref.read(userProvider.notifier).checkAndUpdatePartyStatus();
    }

    if (_selectedIndex != index) {
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
              onPressed: () {},
            ),
          ]
        : [];
    return AppBar(
      centerTitle: true,
      toolbarHeight: MediaQuery.of(context).size.height * 0.05,
      backgroundColor: Color.fromARGB(255, 5, 23, 37),
      title: _isSearching
          ? TextField(
              // When _isSearching is true, show TextField
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
              onSubmitted: (value) {
                // Implement what happens after submission
              },
            )
          : Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                  color: Colors.white)),
      actions: _selectedIndex == 1
          ? [
              !_isSearching
                  ? IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          _isSearching = true; // Toggle search state
                        });
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          _isSearching = false; // Toggle search state
                        });
                      },
                    ),
            ]
          : [],
    );
  }

  Widget _buildOffstageNavigator(int index) {
    return Offstage(
      offstage: _selectedIndex != index,
      child: Navigator(
        key: _navigatorKeys[index],
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          if (index == 3) {
            builder = (BuildContext context) => userHasParty
                ? PartyPage()
                : NoPartyPage(onJoinParty: () {
                    ref.read(userPartyProvider.notifier).state = true;
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => PartyPage()));
                  });
          } else {
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
                // Conditional builder depending on party status
                builder = (BuildContext context) {
                  // Replace this with your actual condition check
                  return userHasParty
                      ? PartyPage()
                      : NoPartyPage(
                          onJoinParty: () {
                            setState(() {
                              userHasParty = true;
                            });
                            // Navigate to the PartyPage after joining a party
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => PartyPage()));
                          },
                        );
                };
                break;
              case 4:
                builder = (BuildContext context) => SettingsPage();
                break;
              default:
                builder = (BuildContext context) =>
                    Center(child: Text('Page Placeholder'));
                break;
            }
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
    bool shouldShowUserStatus =
        _selectedIndex == 0 || _selectedIndex == 1 || _selectedIndex == 2;

    final user = ref.watch(userProvider);
    userHasParty = user?.partyId != null;
    return Theme(
      data: appTheme,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                const UserStatusCard(), // Updated to use Riverpod to fetch data
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
            ? Consumer(
                builder: (context, ref, child) {
                  return FloatingActionButton(
                    child: Icon(Icons.add, color: Colors.white),
                    backgroundColor: Color.fromARGB(255, 14, 31, 46),
                    onPressed: () => showAddDailySheet(context, ref),
                  );
                },
              )
            : _selectedIndex == 0 // For Habits Page
                ? FloatingActionButton(
                    child: Icon(Icons.add, color: Colors.white),
                    backgroundColor: Color.fromARGB(255, 14, 31, 46),
                    onPressed: () => showAddHabitSheet(
                        context, ref), // Call the showAddHabitSheet method
                  )
                : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
