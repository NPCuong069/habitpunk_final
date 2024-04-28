import 'package:flutter/material.dart';
import 'package:habitpunk/src/storage/SecureStorage.dart';
import 'package:habitpunk/src/ui/pages/login_page.dart';

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
          _buildListTile(context, 'Username', 'Piraka',
              trailing: IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () => _showEditUsernameBottomSheet(context),
            )
          ),
              
          _buildListTile(context, 'Email', 'npc06999@gmail.com'),
          _buildSectionHeader('LOGIN METHODS'),
          _buildListTile(context, 'Password', 'Not Set',
              trailing: ElevatedButton(
                  onPressed: () {}, child: Text('Add Password'))),
          _buildListTile(context, 'Google', 'Not Set',
              trailing:
                  OutlinedButton(onPressed: () {}, child: Text('Connect'))),
          _buildListTile(context, 'Apple', 'npc06999@gmail.com',
              trailing: TextButton(
                  onPressed: () {},
                  child:
                      Text('Disconnect', style: TextStyle(color: Colors.red)))),
          _buildSectionHeader('Quit The Game?'),
          ListTile(
            title: Text('Log Out', style: TextStyle(color: Colors.red)),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Text(title,
          style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildListTile(BuildContext context, String title, String subtitle,
      {Widget? trailing, bool isNavigation = false}) {
    return ListTile(
      title: Text(title, style: TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.white70)),
      trailing: trailing,
       onTap: trailing == null
        ? null // Disable tap if there's no trailing widget
        : () => _showEditUsernameBottomSheet(context), // Show bottom sheet when edit icon is tapped
    );
  }

  void _showEditUsernameBottomSheet(BuildContext context) {
  TextEditingController _usernameController = TextEditingController();

  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: Color(0xFF737373), // You might want to change this to fit your dark theme
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Enter new username',
                  ),
                  style: TextStyle(color: Colors.black), // Adjust text style as needed
                ),
                ElevatedButton(
                  child: Text('Change Username'),
                  onPressed: () {
                    // TODO: Add logic to change the username
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}


  void _logout(BuildContext context) async {
    await SecureStorage().deleteSecureData('jwt'); // Delete the JWT token
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginPage()),
      (Route<dynamic> route) => false,
    );
  }
}
