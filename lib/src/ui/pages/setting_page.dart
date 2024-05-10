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
   
      backgroundColor: Color.fromARGB(255, 5, 23, 37),
      body: ListView(
        children: [
          _buildHeader(context),
          _buildMenuSection(title: 'Achievements', onTap: () => _navigateTo(context, 'AchievementsPage')),
          Divider(color: Colors.white54),
          _buildMenuSection(title: 'Subscription', onTap: () => _showSubscriptionModal(context)),
          Divider(color: Colors.white54),
          _buildMenuSection(title: 'Analytics', onTap: () => _navigateTo(context, 'AnalyticsPage')),
        
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return ListTile(
      
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          
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
      SizedBox(height: 10),
      Text(
        'x1.5 exp, x1.5 coins, unlimited dailys and habits',
        style: TextStyle(fontSize: 20, color: Color.fromARGB(179, 212, 0, 255)),
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
                  '${subscriptionOptions[index].benefits}, ${subscriptionOptions[index].gemCap} Coins',
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
        'AchievementsPage': (context) => AchievementsPage(achievements: achievements), // Updated to correct class name
        'AnalyticsPage': (context) => AnalyticsPage(), // assuming this is the class name in analytic_page.dart
      };

      // Use the route name to push the corresponding page
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => routes[routeName]!(context),
      ));
    }

}


