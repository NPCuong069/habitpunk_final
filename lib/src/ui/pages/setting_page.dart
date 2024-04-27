import 'package:flutter/material.dart';
import 'package:habitpunk/src/model/achievement.dart';
import 'package:habitpunk/src/model/subscription.dart';
import 'package:habitpunk/src/ui/pages/achievement_page.dart';
import 'package:habitpunk/src/ui/pages/analytic_page.dart';
import 'package:habitpunk/src/ui/pages/customization_page.dart';
import 'package:habitpunk/src/ui/pages/settings/account_settings.dart';
import 'package:habitpunk/src/ui/pages/shop_page.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedOptionIndex = 0; // Initial selected option index
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
          _buildMenuSection(title: 'Subscription', onTap: () => _showSubscriptionModal(context)),
          Divider(color: Colors.white54),
          _buildMenuSection(title: 'Market', onTap: () => _navigateTo(context, 'MarketPage'),), //subtitle: 'Seasonal items available
          Divider(color: Colors.white54),
          _buildMenuSection(title: 'Customize Avatar', onTap: () => _navigateTo(context, 'CustomizeAvatarPage')),
          Divider(color: Colors.white54),
          _buildMenuSection(title: 'Analytics', onTap: () => _navigateTo(context, 'AnalyticsPage')),
        
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

  void _showSubscriptionModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: Colors.black,
        padding: EdgeInsets.all(20),
        child: _buildSubscriptionContent(context),
      );
    },
  );
}



Widget _buildSubscriptionContent(BuildContext context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Text(
        'Get Premium',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      SizedBox(height: 10),
      Text(
        'Unlock all premium features with a monthly subscription.',
        style: TextStyle(color: Colors.white70),
      ),
      SizedBox(height: 20),
      // Use a flexible widget to ensure the ListView.builder takes only the necessary space
      Flexible(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: subscriptionOptions.length,
          itemBuilder: (context, index) {
            return Card(
              color: Colors.black,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  color: _selectedOptionIndex == index ? Colors.purple : Colors.transparent,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: ListTile(
                leading: Radio(
                  value: index,
                  groupValue: _selectedOptionIndex,
                  onChanged: (int? value) {
                    if (value != null) {
                      setState(() {
                        _selectedOptionIndex = value;
                      });
                    }
                  },
                  activeColor: Colors.purple,
                ),
                title: Text(
                  subscriptionOptions[index].duration,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '${subscriptionOptions[index].benefits}, ${subscriptionOptions[index].gemCap} Gem cap',
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: Text(
                  subscriptionOptions[index].price,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: Colors.purple, // Button color
        ),
        onPressed: () {
          // Handle the selected subscription logic here
          final selectedOption = subscriptionOptions[_selectedOptionIndex];
          // Proceed with the subscription logic using 'selectedOption'
        },
        child: Text('Subscribe Now'),
      ),
      SizedBox(height: 20),
    ],
  );
}


  void _navigateTo(BuildContext context, String routeName) {
  // Map the route names to the actual pages
  Map<String, WidgetBuilder> routes = {
    'CustomizeAvatarPage': (context) => CustomizationPage(), // assuming this is the class name in customization_page.dart
    'MarketPage': (context) => ShopPage(), 
    // Add the analytics page to the routes
      'AnalyticsPage': (context) => AnalyticsPage(),
  };

  Navigator.push(
    context,
    
    MaterialPageRoute(builder: (context) => AchievementsPage(achievements: achievements)),
  );
}
}


