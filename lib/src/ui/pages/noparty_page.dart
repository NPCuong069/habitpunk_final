import 'package:flutter/material.dart';

class NoPartyPage extends StatelessWidget {
  final VoidCallback onJoinParty;

  NoPartyPage({required this.onJoinParty});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Party'),
        backgroundColor: Color.fromARGB(255, 36, 38, 50), // Adjust color to match your theme
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Image.asset('assets/characters.png'), // Replace with your asset path
            ),
            Text(
              'Play Habitica in a Party',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Take on quests with friends or on your own. Battle monsters, create Challenges, and help yourself stay accountable through Parties.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              'Create a new Party',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Image.asset('assets/looking_for_party.png'), // Replace with your asset path
            SizedBox(height: 8),
            Text(
              'Looking for a Party?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Want to join a Party with others but don’t know any other players? Let Party leaders know you’re looking for an invite!',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.purple, // Text color
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text('Look for a Party'),
                onPressed: onJoinParty,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 36, 38, 50), // Set background color
    );
  }
}
