import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/riverpod/invitation_provider.dart';
import 'package:habitpunk/src/riverpod/party_provider.dart';
import 'package:habitpunk/src/ui/pages/party_page.dart';

class PartyInvitation extends StatelessWidget {
  final String inviterAvatar; // URL or asset path for inviter avatar
  final String inviterName;
  final String partyName;
  final VoidCallback onAccept;
  final VoidCallback onDecline;
  final int invitationId;
  PartyInvitation({
    required this.inviterAvatar,
    required this.inviterName,
    required this.partyName,
    required this.onAccept,
    required this.onDecline,
    required this.invitationId,
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
              backgroundImage:
                  AssetImage(inviterAvatar), // Use a NetworkImage if it's a URL
            ),
            SizedBox(width: 8.0),
            Expanded(
              // This will ensure text does not overflow
              child: Text(
                '@$inviterName invited you to join their group $partyName',
                style: TextStyle(color: Colors.white),
                overflow:
                    TextOverflow.ellipsis, // Prevents text from overflowing
                maxLines: 2, // Allows text wrapping if it's too long
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

class NoPartyPage extends ConsumerWidget {
  final VoidCallback onJoinParty;

  NoPartyPage({required this.onJoinParty});

  Future<void> _createParty(WidgetRef ref) async {
    String? partyName = await showDialog<String>(
      context: ref.context,
      builder: (BuildContext context) {
        TextEditingController _controller = TextEditingController();
        return AlertDialog(
          title: Text('Create a New Party'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: 'Enter party name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(_controller.text);
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );

    if (partyName != null && partyName.isNotEmpty) {
      final partyNotifier = ref.read(partyProvider.notifier);
      await partyNotifier.createParty(partyName, 'LEADER_ID');
      Navigator.push(
        ref.context,
        MaterialPageRoute(builder: (context) => PartyPage()),
      );
    }
  }

  void showPartyInvitation(WidgetRef ref) async {
    final invitationNotifier = ref.read(invitationProvider.notifier);
    await invitationNotifier.fetchInvitations();
    List<dynamic> invitations = ref.read(invitationProvider);
    if (invitations.isNotEmpty) {
      var latestInvitation =
          invitations.first; // Displaying the first invitation for simplicity
      ScaffoldMessenger.of(ref.context).showSnackBar(
        SnackBar(
          content: PartyInvitation(
            inviterAvatar:
                'assets/avatar.png', // Ideally this should come from the invitation data
            inviterName: latestInvitation[
                'inviterName'], // Replace with actual attribute names
            partyName: latestInvitation[
                'partyName'], // Replace with actual attribute names
            invitationId: latestInvitation['id'],
            onAccept: () async {
              bool success = await invitationNotifier
                  .acceptInvitation(latestInvitation['id']);
              if (success) {
                // Navigate to the party page or update UI
                Navigator.push(
                  ref.context,
                  MaterialPageRoute(builder: (context) => PartyPage()),
                );
              } else {
                ScaffoldMessenger.of(ref.context).showSnackBar(
                    SnackBar(content: Text("Failed to accept invitation.")));
              }
            },
            onDecline: () {
              // Implement decline functionality
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      );
    } else {
      // Handle no invitations case
      ScaffoldMessenger.of(ref.context).showSnackBar(
        SnackBar(
          content: Text('No invitations available.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(
                'assets/characters.png'), // Replace with your asset path
            Text(
              'Play Habitpunk in a Party',
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
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purple, // Text color
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text('Create a Party'),
                onPressed: () => _createParty(ref),
              ),
            ),
            SizedBox(height: 20),
            Image.asset(
                'assets/looking_for_party.png'), // Replace with your asset path
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
            // SizedBox(height: 20),
            // Center(
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       foregroundColor: Colors.white,
            //       backgroundColor: Colors.purple, // Text color
            //       padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(30.0),
            //       ),
            //     ),
            //     child: Text('Look for a Party'),
            //     onPressed: onJoinParty,
            //   ),
            // ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.purple,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text('Show Invitation'),
                onPressed: () => showPartyInvitation(ref),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Color.fromARGB(255, 36, 38, 50), // Set background color
    );
  }
}
