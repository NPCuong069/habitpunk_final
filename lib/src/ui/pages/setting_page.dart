import 'package:flutter/material.dart';

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
          _buildMenuSection(title: 'Skills', onTap: () => _navigateTo(context, 'SkillsPage')),
          _buildMenuSection(title: 'Stats', onTap: () => _navigateTo(context, 'StatsPage')),
          _buildMenuSection(title: 'Achievements', onTap: () => _navigateTo(context, 'AchievementsPage')),
          Divider(color: Colors.white54),
          _buildMenuSection(title: 'Market', onTap: () => _navigateTo(context, 'MarketPage'), subtitle: 'Seasonal items available'),
          _buildMenuSection(title: 'Quest Shop', onTap: () => _navigateTo(context, 'QuestShopPage')),
          _buildMenuSection(title: 'Seasonal Shop', onTap: () => _navigateTo(context, 'SeasonalShopPage'), subtitle: 'Open for 23d 20h 6m'),
          _buildMenuSection(title: 'Time Travelers Shop', onTap: () => _navigateTo(context, 'TimeTravelersShopPage')),
          Divider(color: Colors.white54),
          _buildMenuSection(title: 'Customize Avatar', onTap: () => _navigateTo(context, 'CustomizeAvatarPage')),
          _buildMenuSection(title: 'Equipment', onTap: () => _navigateTo(context, 'EquipmentPage')),
          _buildMenuSection(title: 'Items', onTap: () => _navigateTo(context, 'ItemsPage')),
          _buildMenuSection(title: 'Pets & Mounts', onTap: () => _navigateTo(context, 'PetsMountsPage')),
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
              // Handle settings action
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
    Navigator.pushNamed(context, routeName);
    // Implement navigation logic, possibly with Navigator.push to a route based on the routeName
  }
}