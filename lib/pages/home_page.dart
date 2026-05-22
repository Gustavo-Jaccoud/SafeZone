import 'package:SafeZone/controllers/map_controller.dart';
import 'package:SafeZone/services/call_service.dart';
import 'package:SafeZone/services/location_service.dart';
import 'package:SafeZone/theme/app_colors.dart';
import 'package:SafeZone/widgets/custom_map.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final Function(double, double) onLocationChanged;

  const HomePage({super.key, required this.onLocationChanged});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? lat;
  double? lng;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomMapWidget(
          showUserLocation: true,
          onLocationChanged: (newLat, newLng) {
            lat = newLat;
            lng = newLng;

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
              onPressed: () {},
              shape: const CircleBorder(),
              backgroundColor: AppColors.white,
              child: const Icon(Icons.add_location, color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
