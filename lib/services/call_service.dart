import 'package:url_launcher/url_launcher.dart';

class CallService {
  static Future<void> callEmergency190() async{
    final Uri phoneUri = Uri.parse('tel:190');
    try {
    await launchUrl(
      phoneUri,
      mode: LaunchMode.externalApplication,
    );
  } catch (e) {
    print('Erro ao ligar: $e');
  }
  }
}