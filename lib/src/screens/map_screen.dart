import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import '../models/LocationData.dart';

const mqttServer = '192.168.1.10';
const mqttPort = 1883; // Default MQTT port
final mqttClientIdentifier = generateRandomString();
//const mqttUsername = 'your_username';
//const mqttPassword = 'your_password';
const mqttTopic = 'location';

String generateRandomString() {
  final random = Random.secure();
  final values = List<int>.generate(16, (i) => random.nextInt(256));
  return base64Url.encode(values);
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  MapController mapController = MapController();
  late StreamSubscription<LocationData> locationSubscription; // Add this line
  MqttClient client = MqttServerClient(mqttServer,
      mqttClientIdentifier); // Replace with your MQTT server details
  LatLng currentMarkerPosition = LocationData.isiLocation;
  String currentAddress = ''; // Add this line
  bool alwaysLookAtRedDot = false;

  @override
  void initState() {
    super.initState();
    // locationSubscription = locationStream.listen((LocationData locationData) {
    //  updateMap(locationData); // Update the map when a new location is received
    // });
    // Connect to the MQTT server and subscribe to a topic
    _connectToMqtt();
  }

  void _connectToMqtt() async {
    client.logging(on: true);
    client.keepAlivePeriod = 30;
    client.onConnected = _onMqttConnected;
    client.onDisconnected = _onMqttDisconnected;

    final MqttConnectMessage connectMessage =
        MqttConnectMessage().withClientIdentifier(mqttClientIdentifier);

    client.connectionMessage = connectMessage;

    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
    }
  }

  void _onMqttConnected() {
    print('Connected to MQTT');
    client.subscribe(mqttTopic, MqttQos.atMostOnce);
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      final String payload =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print("Payload: $payload");

      // Parse the payload to get location data
      LocationData locationData = LocationData.fromPayload(payload);
      updateMap(locationData);
    });
  }

  void _onMqttDisconnected() {
    print('Disconnected from MQTT');
  }

  @override
  void dispose() {
    locationSubscription
        .cancel(); // Cancel the subscription to avoid memory leaks
    super.dispose();
  }

  // Replace this method with your actual stream source
  Stream<LocationData> get locationStream {
    // You need to replace this with your actual location stream source
    // For example, you can use a package like location or geolocator
    // Here, we're simulating a stream with periodic updates for demonstration purposes
    return Stream<LocationData>.periodic(
      const Duration(seconds: 8),
      (count) => LocationData(51.509364 + count * 0.001, -0.128928),
    );
  }

  void updateMap(LocationData locationData) async {
    setState(() {
      currentMarkerPosition =
          LatLng(locationData.latitude, locationData.longitude);
      placemarkFromCoordinates(locationData.latitude!, locationData.longitude!)
          .then((List<Placemark> placemarks) {
        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;
          String newAddress = placemark.street!;
          print('Address changed: $newAddress');

          setState(() {
            currentAddress = newAddress;
          });

          if (alwaysLookAtRedDot) {
            // Always look at the red dot
            mapController.move(currentMarkerPosition, mapController.zoom);
          }
        }
      }).catchError((error) {
        print("Error during reverse geocoding: $error");
      });
    });
  }

  void centerOnRedDot() {
    mapController.move(
        currentMarkerPosition, 18.0); // Adjust zoom level as needed
  }

  void toggleAlwaysLookAtRedDot() {
    setState(() {
      alwaysLookAtRedDot = !alwaysLookAtRedDot;
      if (alwaysLookAtRedDot) {
        // If toggled on, immediately look at the red dot
        mapController.move(currentMarkerPosition, mapController.zoom);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: const MapOptions(
              initialCenter: LocationData.isiLocation,
              initialZoom: 15.0, // Adjust the initialZoom value as needed
              maxZoom: 18.0,
              minZoom: 3.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app',
              ),
              MarkerLayer(markers: [
                Marker(
                  width: 50.0,
                  height: 50.0,
                  point: currentMarkerPosition,
                  child: Image.asset(
                    './assets/images/location.png', // Update the path
                    width: 50.0,
                    height: 50.0,
                  ),
                ),
              ]),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        currentAddress,
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.center_focus_strong),
                          onPressed: centerOnRedDot,
                        ),
                        IconButton(
                          icon: Icon(alwaysLookAtRedDot
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: toggleAlwaysLookAtRedDot,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
