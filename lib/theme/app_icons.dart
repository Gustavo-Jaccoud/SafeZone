import 'package:SafeZone/theme/app_colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';

class AppIcons {
  static final nova_ocorrencia = SvgPicture.asset(
    'assets/images/nova_ocorrencia.svg',
    height: 23,
    colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
  );

  static final boletim_ocorrencia = Image.asset(
    'assets/images/boletim_ocorrencia.png',
    height: 25,
  );
  static final abusoSexual = Image.asset(
    'assets/images/abuso_sexual.png',
    height: 25,
  );
  static final acidenteTransito = Image.asset(
    'assets/images/acidente_transito.png',
    height: 25,
  );
  static final agressao = Image.asset(
    'assets/images/agressao.png',
    height: 25,
  );
  static final ameaca = Image.asset(
    'assets/images/ameaca.png',
    height: 25,
  );
  static final homicidio = Image.asset(
    'assets/images/homicidio.png',
    height: 25,
  );
  static final roubo = Image.asset(
    'assets/images/roubo.png',
    height: 25,
  );
  static final sequestro = Image.asset(
    'assets/images/sequestro.png',
    height: 25,
  );
  static final vandalismo = Image.asset(
    'assets/images/vandalismo.png',
    height: 25,
  );
  static final novaOcorrencia = Image.asset(
    'assets/images/novaocorrencia.png',
    height: 35,
  );
  static final editarOcorrencia = Image.asset(
    'assets/images/editarocorrencia.png',
    height: 35,
  );

}
