import 'package:flutter/material.dart';
import 'package:habitpunk/src/ui/pages/customization_page.dart';
import 'package:habitpunk/src/ui/pages/settings/account_settings.dart';
import 'package:habitpunk/src/ui/pages/shop_page.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          _buildHeader(context),
          _buildMenuSection(title: 'Achievements', onTap: () => _navigateTo(context, 'AchievementsPage')),
          Divider(color: Colors.white54),
          _buildMenuSection(title: 'Market', onTap: () => _navigateTo(context, 'MarketPage'),), //subtitle: 'Seasonal items available
          Divider(color: Colors.white54),
          _buildMenuSection(title: 'Customize Avatar', onTap: () => _navigateTo(context, 'CustomizeAvatarPage')),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage('https://via.placeholder.com/150'),
      ),
      title: Text(
        'Username',
        style: TextStyle(color: Colors.white),
      ),
      subtitle: Text(
        '@Handle',
        style: TextStyle(color: Colors.white70),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.chat_bubble, color: Colors.white),
            onPressed: () {
              // Handle chat action
            },
          ),
          IconButton(
            icon: Icon(Icons.mail, color: Colors.white),
            onPressed: () {
              // Handle mail action
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
          onPressed: () {
              // Navigate to the SettingsPage
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AccountSettingsPage(),
              ));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection({required String title, VoidCallback? onTap, String? subtitle}) {
    return ListTile(
      title: Text(title, style: TextStyle(color: Colors.white)),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: Colors.white70)) : null,
      trailing: Icon(Icons.chevron_right, color: Colors.white),
      onTap: onTap,
    );
  }

  void _navigateTo(BuildContext context, String routeName) {
  // Map the route names to the actual pages
  Map<String, WidgetBuilder> routes = {
    'CustomizeAvatarPage': (context) => CustomizationPage(), // assuming this is the class name in customization_page.dart
    'MarketPage': (context) => ShopPage(), // assuming this is the class name in shop_page.dart
  };

  Navigator.push(
    context,
    MaterialPageRoute(builder: routes[routeName]!),
  );
}
}