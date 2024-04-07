import 'package:flutter/material.dart';

class AccountSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          _buildSectionHeader('ACCOUNT INFO'),
          _buildListTile(context, 'Username', 'Piraka', trailing: Icon(Icons.edit, color: Colors.white)),
          _buildListTile(context, 'Email', 'npc06999@gmail.com'),
          _buildSectionHeader('LOGIN METHODS'),
          _buildListTile(context, 'Password', 'Not Set', trailing: ElevatedButton(onPressed: () {}, child: Text('Add Password'))),
          _buildListTile(context, 'Google', 'Not Set', trailing: OutlinedButton(onPressed: () {}, child: Text('Connect'))),
          _buildListTile(context, 'Apple', 'npc06999@gmail.com', trailing: TextButton(onPressed: () {}, child: Text('Disconnect', style: TextStyle(color: Colors.red)))),
          _buildSectionHeader('PUBLIC PROFILE'),
          _buildListTile(context, 'Display name', 'hb-581d350wg1d79myvv'),
          _buildListTile(context, 'About', ''),
          _buildListTile(context, 'Photo URL', ''),
          _buildSectionHeader('API'),
          _buildListTile(context, 'User ID', 'b93aaa57-4900-41cb-907c-4aa997417240'),
          _buildListTile(context, 'API Key', 'Copy Token. Be careful, this is a password!'),
          _buildListTile(context, 'Fix Character Values', '', isNavigation: true),
          _buildSectionHeader('DANGER ZONE'),
          ListTile(
            title: Text('Reset Account', style: TextStyle(color: Colors.red)),
            onTap: () {
              // Handle reset account
            },
          ),
          ListTile(
            title: Text('Delete Account', style: TextStyle(color: Colors.red)),
            onTap: () {
              // Handle delete account
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(title, style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildListTile(BuildContext context, String title, String subtitle, {Widget? trailing, bool isNavigation = false}) {
    return ListTile(
      title: Text(title, style: TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.white70)),
      trailing: trailing,
      onTap: isNavigation ? () {
        // Handle navigation
      } : null,
    );
  }
}
