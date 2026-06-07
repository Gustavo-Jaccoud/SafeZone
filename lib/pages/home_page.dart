import 'package:SafeZone/controllers/map_controller.dart';
import 'package:SafeZone/models/ocorrencia.dart';
import 'package:SafeZone/services/call_service.dart';
import 'package:SafeZone/services/location_service.dart';
import 'package:SafeZone/firebase/ocorrencia_service.dart';
import 'package:SafeZone/theme/app_colors.dart';
import 'package:SafeZone/theme/app_icons.dart';
import 'package:SafeZone/widgets/custom_map.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final Function(double, double) onLocationChanged;
  final VoidCallback onCadastrarPressed;
  
  final List<Ocorrencia> ocorrencias;
  final String enderecoAtual;

  const HomePage({
    super.key,
    required this.onLocationChanged,
    required this.onCadastrarPressed,
    required this.ocorrencias,   
    required this.enderecoAtual,  
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? lat;
  double? lng;
  
  List<Ocorrencia> _ocorrenciasProximas = [];
  final _ocorrenciaService = OcorrenciaService();

  Future<void> _buscarDadosDoFirebase(double latitude, double longitude) async {
    try {
      final dados = await _ocorrenciaService.buscarOcorrenciasProximas(
        userLat: latitude,
        userLng: longitude,
        raioEmKm: 10, 
      );
      
      setState(() {
        _ocorrenciasProximas = dados;
      });
    } catch (e) {
      debugPrint("Erro ao carregar ocorrências próximas: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomMapWidget(
          showUserLocation: true,
          onLocationChanged: (newLat, newLng) {
            lat = newLat;
            lng = newLng;
            
            _buscarDadosDoFirebase(newLat, newLng);
            
            widget.onLocationChanged(newLat, newLng);
          },
        ),
        Positioned(
          bottom: 110,
          right: 20,
          child: FloatingActionButton(
            heroTag: "center_map",
            onPressed: () async {
              if (lat == null || lng == null) return;
              await MapControllerService.centerOn(lat!, lng!);
            },
            shape: const CircleBorder(),
            backgroundColor: AppColors.white,
            child: const Icon(Icons.my_location, color: AppColors.primary),
          ),
        ),
        Positioned(
          bottom: 190,
          left: 20,
          child: SizedBox(
            width: 58,
            height: 58,
            child: FloatingActionButton(
              heroTag: "left_action_1",
              onPressed: () async {
                await CallService.callEmergency190();
              },
              shape: const CircleBorder(),
              backgroundColor: AppColors.white,
              child: const Icon(Icons.phone, color: AppColors.primary),
            ),
          ),
        ),
        Positioned(
          bottom: 110,
          left: 20,
          child: SizedBox(
            width: 58,
            height: 58,
            child: FloatingActionButton(
              heroTag: "left_action_2",
              onPressed: () async {
                if (lat == null || lng == null) return;
                
                await _ocorrenciaService.registrarOcorrencia(
                  Ocorrencia(
                    tipo: TipoOcorrencia.roubo,
                    descricao: 'Roubo de celular na rua',
                    data: DateTime.now(),
                    endereco: widget.enderecoAtual.isNotEmpty 
                        ? widget.enderecoAtual 
                        : "Endereço Desconhecido",
                    latitude: lat!,
                    longitude: lng!,
                  ),
                );
                
                _buscarDadosDoFirebase(lat!, lng!);
              },
              shape: const CircleBorder(),
              backgroundColor: AppColors.white,
              child: AppIcons.nova_ocorrencia,
            ),
          ),
        ),
      ],
    );
  }
}