import 'package:SafeZone/app/app_shell.dart';
import 'package:SafeZone/pages/login_start_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'pages/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: ".env");

  final token = dotenv.env['MAPBOX_TOKEN'];

  if (token == null || token.isEmpty) {
    throw Exception('MAPBOX_TOKEN não encontrado no .env');
  }

  MapboxOptions.setAccessToken(token);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('pt', 'BR'),
  supportedLocales: const [
    Locale('pt', 'BR'),
  ],
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
      debugShowCheckedModeBanner: false,
      home: const LoginStartPage(),
    );
  }
}