import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitpunk/src/model/daily.dart';
import 'package:habitpunk/src/riverpod/daily_provider.dart';
import 'package:habitpunk/src/storage/secureStorage.dart';

class DailiesPage extends ConsumerStatefulWidget {
  @override
  DailiesPageState createState() => DailiesPageState();
}

class DailiesPageState extends ConsumerState<DailiesPage> {
  String _jwt = "";

  @override
  void initState() {
    super.initState();
    _loadJwtAndDailies();
  }

  Future<void> _onRefresh() async {
    await _loadJwtAndDailies(); // Re-fetch the dailies when pulled to refresh
  }

  Future<void> _loadJwtAndDailies() async {
    String? jwt = await SecureStorage().readSecureData('jwt');
    if (jwt != null) {
      setState(() {
        _jwt = jwt;
      });
      ref.read(dailyProvider.notifier).fetchDailies();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dailies = ref.watch(dailyProvider); // Watching the dailies state

    return Scaffold(
      key: GlobalKey<ScaffoldState>(),
      backgroundColor: Color.fromARGB(255, 5, 23, 37),
      appBar: AppBar(
        title: Text('Dailies'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => _showJwtDialog(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          itemCount: dailies.length,
          itemBuilder: (context, index) {
            final daily = dailies[index];
            return DailyItem(
              daily: daily,
              onChecked: (bool? newValue) {
                if (newValue != null) {
                  ref
                      .read(dailyProvider.notifier)
                      .checkOffDaily(daily.id, newValue);
                }
              },
            );
          },
        ),
      ),
    );
  }

  void _showJwtDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('JWT Token'),
        content: SelectableText(_jwt.isEmpty ? "No token loaded." : _jwt),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

class DailyItem extends StatelessWidget {
  final Daily daily;
  final Function(bool?) onChecked;

  const DailyItem({
    Key? key,
    required this.daily,
    required this.onChecked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = daily.completed ? Colors.transparent : Colors.blue;
    bool checkboxEnabled = !daily.completed;
    return Container(
      margin: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 36, 38, 50),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        minVerticalPadding: 0,
        leading: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor, // Background color for the add icon
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(4.0), // Top-left corner rounded
              bottomLeft: Radius.circular(4.0), // Bottom-left corner rounded
            ),
          ),
          child: Checkbox(
            value: daily.completed,
            onChanged: checkboxEnabled ? onChecked : null,
          ),
        ),
        title: Text(
          daily.title,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          daily.note,
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
