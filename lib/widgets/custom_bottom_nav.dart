import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int paginaAtual;
  final Function(int) onTap;
  final String bairroAtual;

  const CustomBottomNav({
    super.key,
    required this.paginaAtual,
    required this.onTap,
    required this.bairroAtual,
  });

  @override
  Widget build(BuildContext context) {
    print(bairroAtual);
    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [
        Container(
          width: double.infinity,

          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),

          decoration: const BoxDecoration(
            color: AppColors.primaryDark,

            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),

          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppColors.primary,
              ),

              SizedBox(width: 8),

              Text(
                bairroAtual,

                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        BottomNavigationBar(
          backgroundColor: AppColors.white,

          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textDark,

          currentIndex: paginaAtual,

          onTap: onTap,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.warning_amber_rounded),
              label: 'Ocorrências',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_ind_outlined),
              label: 'Minhas Ocorrências',
            ),
          ],
        ),
      ],
    );
  }
}