import 'package:SafeZone/theme/app_colors.dart';
import 'package:SafeZone/widgets/custom_map.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final Function(double, double) onLocationChanged;

  const HomePage({super.key, required this.onLocationChanged});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomMapWidget(
          showUserLocation: true,
          onLocationChanged: onLocationChanged,
        ),

        Positioned(
          bottom: 110,
          right: 20,
          child: SizedBox(
            width: 58,
            height: 58,
            child: FloatingActionButton(
              heroTag: "center_map",
              onPressed: () {},
              shape: const CircleBorder(),
              backgroundColor: AppColors.white,
              child: const Icon(Icons.my_location, color: AppColors.primary),
            ),
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
              onPressed: () {},
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
