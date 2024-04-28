import 'package:flutter/material.dart';

class PartyInvitation extends StatelessWidget {
  final String inviterAvatar; // URL or asset path for inviter avatar
  final String inviterName;
  final String partyName;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  PartyInvitation({
    required this.inviterAvatar,
    required this.inviterName,
    required this.partyName,
    required this.onAccept,
    required this.onDecline,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[900], // Adjust the color to match the theme
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage(inviterAvatar), // Use a NetworkImage if it's a URL
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Text(
                '@$inviterName invited you to join their group $partyName',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(width: 8.0),
            GestureDetector(
              onTap: onDecline,
              child: Icon(Icons.close, color: Colors.red),
            ),
            SizedBox(width: 8.0),
            GestureDetector(
              onTap: onAccept,
              child: Icon(Icons.check, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}


class NoPartyPage extends StatelessWidget {
  final VoidCallback onJoinParty;

  NoPartyPage({required this.onJoinParty});

  // Call this method with the invitation data
  void showPartyInvitation(BuildContext context, String inviterName, String partyName) {
  // Function to show the custom party invitation
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: PartyInvitation(
        inviterAvatar: 'assets/avatar.png', // Replace with the actual avatar asset path
        inviterName: inviterName,
        partyName: partyName,
        onAccept: () {
          // TODO: Handle accept action
        },
        onDecline: () {
          // TODO: Handle decline action
        },
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
  );
}

  
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
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.purple, // Text color
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text('Create a Party'),
                onPressed: onJoinParty,
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
            SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, backgroundColor: Colors.purple,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: Text('Show Invitation'),
                  onPressed: () => showPartyInvitation(context, 'InviterName', 'Cool Party Name'),
                ),
              ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 36, 38, 50), // Set background color
    );
  }
}
