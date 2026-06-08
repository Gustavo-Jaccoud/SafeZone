import 'package:SafeZone/pages/cadastrar_ocorrencia_page.dart';
import 'package:SafeZone/pages/home_page.dart';
import 'package:SafeZone/pages/minhas_ocorrencias_page.dart';
import 'package:SafeZone/services/location_service.dart';
import 'package:SafeZone/widgets/custom_app_bar.dart';
import 'package:SafeZone/widgets/custom_bottom_nav.dart';
import 'package:SafeZone/widgets/OcorrenciasPainel.dart';
import 'package:SafeZone/models/ocorrencia.dart'; // 1. IMPORTANTE: Adiciona o import do modelo
import 'package:SafeZone/firebase/ocorrencia_service.dart'; // 2. IMPORTANTE: Adiciona o import do serviço
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
  final ocorrenciaService = OcorrenciaService(); 

  List<Ocorrencia> ocorrenciasProximas = [];

  void _onLocationChanged(double newLat, double newLng) async {
    lat = newLat;
    lng = newLng;
    
    try {
      final dados = await ocorrenciaService.buscarOcorrenciasProximas(
        userLat: newLat,
        userLng: newLng,
        raioEmKm: 10,
      );
      setState(() {
        ocorrenciasProximas = dados;
      });
    } catch (e) {
      debugPrint("Erro ao carregar ocorrências no Shell: $e");
    }

    final newPlace = await locationService.getPlaceFromCoords(newLat, newLng);
    if (newPlace != null && newPlace != place) {
      setState(() {
        place = newPlace;
      });
    }
  }

  void _onCadastrarPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CadastrarOcorrenciaPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final enderecoTexto = (place?.subLocality?.isNotEmpty == true)
        ? place!.subLocality!
        : "Localizando...";

    final List<Widget> paginas = [
      Padding(
        padding: const EdgeInsets.only(top: 80),
        child: HomePage(
          onLocationChanged: _onLocationChanged,
          onCadastrarPressed: _onCadastrarPressed,
          ocorrencias: ocorrenciasProximas, 
          enderecoAtual: enderecoTexto, 
        ),
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
              maxChildSize: 0.88,
              builder: (context, scrollController) {
                return NotificationListener<DraggableScrollableNotification>(
                  onNotification: (notification) {
                    if (notification.extent <= 0.21) {
                      setState(() {
                        exibirPainelOcorrencias = false;
                      });
                    }
                    return true;
                  },
                  child: OcorrenciasPainel(
                    scrollController: scrollController,
                    ocorrencias: ocorrenciasProximas, 
                  ),
                );
              },
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        paginaAtual: exibirPainelOcorrencias ? 1 : paginaAtual,
        enderecoAtual: enderecoTexto,
        onTap: (index) {
          if (index == 1) {
            setState(() {
              exibirPainelOcorrencias = !exibirPainelOcorrencias;
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