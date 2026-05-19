import 'package:SafeZone/pages/home_page.dart';
import 'package:SafeZone/widgets/custom_app_bar.dart';
import 'package:SafeZone/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int paginaAtual = 0;

  void _onLocationChanged(double lat, double lng) {}

  @override
  Widget build(BuildContext context) {
    final List<Widget> paginas = [
      HomePage(onLocationChanged: _onLocationChanged),
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
        bairroAtual: "Farolandia",
        onTap: (index) {
          setState(() => paginaAtual = index);
        },
      ),
    );
  }
}
