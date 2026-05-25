import 'package:SafeZone/pages/home_page.dart';
import 'package:SafeZone/pages/minhas_ocorrencias_page.dart';
import 'package:SafeZone/services/location_service.dart';
import 'package:SafeZone/widgets/custom_app_bar.dart';
import 'package:SafeZone/widgets/custom_bottom_nav.dart';
import 'package:SafeZone/widgets/OcorrenciasPainel.dart';
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
  
  bool exibirPainelOcorrencias = false;

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
        padding: const EdgeInsets.only(top: 80),
        child: HomePage(onLocationChanged: _onLocationChanged),
      ),
      const Center(child: Text('Ocorrências')),
      const Padding(
        padding: EdgeInsets.only(top: 80),
        child: MinhasOcorrenciasPage(),
      ),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          paginas[paginaAtual],

          if (exibirPainelOcorrencias && paginaAtual == 0)
            DraggableScrollableSheet(
              initialChildSize: 0.65,
              minChildSize: 0.2,
              maxChildSize: 0.85,
              builder: (context, scrollController) {
                // Adicionamos um NotificationListener para detectar se o usuário 
                // arrastou o painel todo para baixo para fechar
                return NotificationListener<DraggableScrollableNotification>(
                  onNotification: (notification) {
                    // Se o usuário arrastou para o tamanho mínimo (0.2), fechamos o painel
                    if (notification.extent <= 0.21) {
                      setState(() {
                        exibirPainelOcorrencias = false;
                      });
                    }
                    return true;
                  },
                  child: OcorrenciasPainel(scrollController: scrollController),
                );
              },
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        // LOGICA VISUAL: Se o painel estiver aberto, força a BottomNav a acender o ícone 1 (Ocorrências).
        // Se o painel fechar, ela volta automaticamente para o valor de paginaAtual (0 - Home).
        paginaAtual: exibirPainelOcorrencias ? 1 : paginaAtual,
        bairroAtual: (place?.subLocality?.isNotEmpty == true)
            ? place!.subLocality!
            : "Localizando...",
        onTap: (index) {
          if (index == 1) {
            setState(() {
              exibirPainelOcorrencias = !exibirPainelOcorrencias;
              // Se estamos abrindo o painel, garantimos que a página base de fundo seja a Home (0)
              if (exibirPainelOcorrencias) {
                paginaAtual = 0;
              }
            });
          } else {
            setState(() {
              paginaAtual = index;
              exibirPainelOcorrencias = false;
            });
          }
        },
      ),
    );
  }
}