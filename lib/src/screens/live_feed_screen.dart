import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

// ignore: use_key_in_widget_constructors
class LiveFeedScreen extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _LiveFeedScreenState createState() => _LiveFeedScreenState();
}

class _LiveFeedScreenState extends State<LiveFeedScreen> {
  late VlcPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller = VlcPlayerController.network(
      'rtsp://192.168.1.10:8554/', // Replace with your RTSP server address
      hwAcc: HwAcc.disabled,
      autoInitialize: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Feed Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            VlcPlayer(
              aspectRatio: 16 / 9,
              controller: _controller,
              placeholder: const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Stop the video playback and dispose the controller when navigating back
                _controller.stop();
                _controller.dispose();
                Navigator.pop(context);
              },
              child: const Text('Stop and Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
