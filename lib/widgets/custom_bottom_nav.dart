import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int paginaAtual;
  final Function(int) onTap;
  final String enderecoAtual;

  const CustomBottomNav({
    super.key,
    required this.paginaAtual,
    required this.onTap,
    required this.enderecoAtual,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [
        Container(
          width: double.infinity,

          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),

          decoration: const BoxDecoration(
            color: AppColors.primaryDark,

            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),

          child: Row(
            children: [
              Icon(Icons.location_on, color: AppColors.primary),

              SizedBox(width: 8),

              Text(
                enderecoAtual,

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

          items:  [
            BottomNavigationBarItem(icon: SvgPicture.asset('assets/images/mapa.svg', height: 20, colorFilter: ColorFilter.mode(paginaAtual == 0 ?AppColors.primary:AppColors.textDark, BlendMode.srcIn)), label: 'Explorar'),

            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/images/ocorrencias.svg', height: 20, colorFilter: ColorFilter.mode(paginaAtual == 1 ?AppColors.primary:AppColors.textDark, BlendMode.srcIn)),
              label: 'Ocorrências',
            ),

            BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/images/minhas_ocorrencias.svg', height: 20, colorFilter: ColorFilter.mode(paginaAtual == 2 ?AppColors.primary:AppColors.textDark, BlendMode.srcIn)),
              label: 'Minhas Ocorrências',
            ),
          ],
        ),
      ],
    );
  }
}
