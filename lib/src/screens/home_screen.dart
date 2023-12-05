import 'package:flutter/material.dart';
import 'package:smart_glasses_flutter/src/screens/live_feed_screen.dart';
import 'package:smart_glasses_flutter/src/screens/map_screen.dart';

class HomeScreen extends StatelessWidget {
  TextEditingController _urlController = TextEditingController();

  // Default stream URL
  final String defaultStreamUrl = 'rtsp://admin:admin@192.168.1.2:1935/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the Map Screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapScreen()),
                );
              },
              child: Text('Go to Map Screen'),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Show a dialog to get the stream URL
                _showStreamUrlDialog(context);
              },
              child: Text('Go to Live Feed Screen'),
            ),
          ],
        ),
      ),
    );
  }

  void _showStreamUrlDialog(BuildContext context) {
    _urlController.text = defaultStreamUrl; // Set default value

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Stream URL'),
          content: TextField(
            controller: _urlController,
            decoration: InputDecoration(labelText: 'Stream URL'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Navigate to the Live Feed Screen with the provided stream URL
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LiveFeedScreen(
                      streamUrl: _urlController.text,
                    ),
                  ),
                );
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
