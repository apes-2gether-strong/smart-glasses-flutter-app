import 'package:flutter/material.dart';
import 'package:smart_glasses_flutter/src/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("hi");
  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  /*await Supabase.initialize(
      url: 'https://xupigecakyyfpvdyjzzi.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inh1cGlnZWNha3l5ZnB2ZHlqenppIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTg0NDMwODcsImV4cCI6MjAxNDAxOTA4N30.jLRB0votsPcE1NLmCAf8UD-GBYHgLqMivJWZ-fsFgME',
      // authCallbackUrlHostname: 'login-callback', // optional
      debug: true // optional
      );*/
  runApp(const MyApp());
}

//final supabase = Supabase.instance.client;

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

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
