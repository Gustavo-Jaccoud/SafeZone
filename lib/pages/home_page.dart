import 'package:SafeZone/widgets/custom_map.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_app_bar.dart';
import '../widgets/custom_bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;
  String bairroAtual = "Farolandia";

  void _onLocationChanged(double lat, double lng) {
    print("Nova localização: $lat, $lng");
  }

  @override
  Widget build(BuildContext context) {
    final paginas = [
      CustomMapWidget(
        showUserLocation: true,
        onLocationChanged: _onLocationChanged,
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
        bairroAtual: bairroAtual,
        onTap: (index) {
          setState(() {
            paginaAtual = index;
          });
        },
      ),
    );
  }
}