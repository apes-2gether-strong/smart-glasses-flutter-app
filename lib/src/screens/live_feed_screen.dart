import 'package:flutter/material.dart';
import 'package:flutter_vlc_player/flutter_vlc_player.dart';

class LiveFeedScreen extends StatefulWidget {
  final String streamUrl;

  // Constructor with a default value for streamUrl
  LiveFeedScreen({this.streamUrl = 'rtsp://admin:admin@192.168.1.2:1935/'});
  @override
  _LiveFeedScreenState createState() => _LiveFeedScreenState();
}

class _LiveFeedScreenState extends State<LiveFeedScreen> {
  late VlcPlayerController _controller;
  bool isPlayerInitialized = true;

  @override
  void initState() {
    super.initState();
    try {
      _controller = VlcPlayerController.network(
        widget.streamUrl,
        hwAcc: HwAcc.full,
        autoInitialize: true,
        autoPlay: true,
        options: VlcPlayerOptions(),
      );
    } catch (e) {
      // Handle the exception here
      print('Error initializing VlcPlayerController: $e');
      // You can show an error message to the user or take other actions
    }
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
            const SizedBox(height: 20.0),
            VlcPlayer(
              aspectRatio: 16 / 9,
              controller: _controller,
              placeholder: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            const SizedBox(height: 20.0),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
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
