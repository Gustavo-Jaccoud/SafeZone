import 'package:SafeZone/pages/home_page.dart';
import 'package:SafeZone/services/location_service.dart';
import 'package:SafeZone/widgets/custom_app_bar.dart';
import 'package:SafeZone/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int paginaAtual = 0;
  double? lat;
  double? lng;
  Placemark? place;

  final locationService = LocationService();
  void _onLocationChanged(double newLat, double newLng) async {
    lat = newLat;
    lng = newLng;

    final newPlace = await locationService.getPlaceFromCoords(newLat, newLng);

    if (newPlace != null && newPlace != place) {
      setState(() {
        place = newPlace;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> paginas = [
      Padding(
        padding: EdgeInsets.only(top: 80),
        child: HomePage(onLocationChanged: _onLocationChanged),
      ),
      const Center(child: Text('Ocorrências')),
      const Center(child: Text('Minhas Ocorrências')),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: CustomAppBar(),
      body: paginas[paginaAtual],
      bottomNavigationBar: CustomBottomNav(
        paginaAtual: paginaAtual,
        bairroAtual: (place?.subLocality?.isNotEmpty == true)
            ? place!.subLocality!
            : "Localizando...",
        onTap: (index) {
          setState(() => paginaAtual = index);
        },
      ),
    );
  }
}
