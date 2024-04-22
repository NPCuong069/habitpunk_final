import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/riverpod/user_provider.dart';
import 'package:habitpunk/src/model/user.dart';

Widget _buildItemWidget(int itemId) {
  // Correct the file path if necessary
  String imagePath = 'images/items/${itemId.toString()}.png';
  // Adjust the size and positioning as necessary
  return Positioned(
    top: 10, // Position the item in the stack, customize as needed
    left: 10,
    child: Image.asset(imagePath, width: 40, height: 40), // Adjust the size as needed
  );
}



// Make sure to create a 'stat_bar.dart' if you haven't already.
class StatBar extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final Color color;
  final IconData icon;

  const StatBar({
    Key? key,
    required this.label,
    required this.value,
    required this.maxValue,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(
            icon, // Change this line
            color: color,
            size: 16,
          ),
          SizedBox(width: 4),
          Expanded(
            child: LinearProgressIndicator(
              value: value / maxValue.toDouble(),
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          SizedBox(width: 4),
          Text('$value / $maxValue', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
class UserStatusCard extends ConsumerWidget {
  const UserStatusCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use Riverpod to get the user data.
    final userAsyncValue = ref.watch(userProvider);

    // Placeholder image URL for the dummy avatar.
    const String dummyAvatarUrl = 'https://dummyimage.com/150x150/000/fff&text=Avatar';

    return userAsyncValue.when(
      data: (user) => _buildCard(context, user, dummyAvatarUrl),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }

  Widget _buildCard(BuildContext context, User user, String dummyAvatarUrl) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                // Container to hold the avatar and items
                Container(
                  width: 100, // Width and height to create a square
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white, // Border color
                      width: 3, // Border width
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          dummyAvatarUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                      if (user.hatId != 0)
                        Positioned(
                          top: 10,
                          child: _buildItemWidget(user.hatId),
                        ),
                      if (user.costumeId != 0)
                        Positioned(
                          top: 30,
                          child: _buildItemWidget(user.costumeId),
                        ),
                      // Add more Positioned widgets for other items
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatBar(
                        label: 'Health',
                        value: user.hp,
                        maxValue: user.maxHealth, // Add maxHealth to User model
                        color: Colors.red,
                        icon: Icons.favorite,
                      ),
                      StatBar(
                        label: 'Energy',
                        value: user.en,
                        maxValue: user.maxMana, // Add maxMana to User model
                        color: Colors.blue,
                        icon: Icons.electric_bolt,
                      ),
                      StatBar(
                        label: 'Experience',
                        value: user.xp,
                        maxValue: user.nextLevelExp, // Add nextLevelExp to User model
                        color: Colors.amber,
                        icon: Icons.star,
                      ),
                    ],
                  ),
                ),
                
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Level ${user.lvl}', style: TextStyle(color: Colors.white)),
                Text(user.userClass, style: TextStyle(color: Colors.white)), // Add userClass to User model
              ],
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.5, color: Color.fromARGB(255,14,31,46)),
        ),
      ),
    );
  }
}