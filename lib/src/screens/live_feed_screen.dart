import 'package:flutter/material.dart';

class LiveFeedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'This is the second screen',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the tracking page
                Navigator.pop(context);
              },
              child: Text('Go Back to Tracking Page'),
            ),
          ],
        ),
      ),
    );
  }
}
