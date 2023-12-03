import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:smart_glasses_flutter/src/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //MediaKit.ensureInitialized();

  print("hi");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const [
        Locale('en', ''), // English, no country code
      ],
      // Define a light and dark color theme. Then, read the user's
      // preferred ThemeMode (light, dark, or system default) from the
      theme: ThemeData(),
      darkTheme: ThemeData.dark(),

      title: 'Smart glasses',

      home: SmartGlassesAppHomeScreen(),
    );
  }
}
