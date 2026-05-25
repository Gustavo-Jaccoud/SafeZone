import 'package:SafeZone/app/app_shell.dart';
import 'package:SafeZone/pages/login_start_page.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'pages/home_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      debugShowCheckedModeBanner: false,
    home: const LoginStartPage(),
    );
  }
}

