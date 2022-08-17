import 'package:utilizacion_bloc/environment/environment.dart';
import 'package:utilizacion_bloc/utils/reg_exp_utils.dart';

class TelefonoModel {
  static String numeroTelefonoToSafe(
      {String? codigoPais = '', required String numero}) {
    return '$codigoPais$numero'.replaceAll(RegExp(r'[+ ]{1}'), '').trim();
  }

  ///Esta funcion recibe un numero de telefono y lo descompone para ser
  ///visualizado
  ///[parametros] requiere el numero del telefono
  ///Se debe pasar numero completo con codigo del pais
  static Map<String, dynamic> telefonoToView(String telefono) {
    String newTelefono = telefono.replaceAll(RegExp(r'[+ ]{1}'), '').trim();
    if (!RegExpUtils.validaNumero(newTelefono) && newTelefono.isNotEmpty) {
      return {'CodigoPais': '', 'numero': newTelefono};
    }
    String codigoPais = '';
    Environment.lstCodigoPais.forEach((key, value) {
      if (newTelefono.startsWith(key)) {
        codigoPais = key;
        newTelefono = newTelefono.substring(key.length);
      }
    });

    if (newTelefono.length > 6) {
      String prefijoWhatsApp = '';
      if (newTelefono.startsWith('9')) {
        prefijoWhatsApp = '9';
        newTelefono = newTelefono.substring(1);
      }

      if (newTelefono.startsWith('11')) {
        newTelefono =
            '${newTelefono.substring(0, 2)} ${newTelefono.substring(2, 6)} ${newTelefono.substring(6)}';
      } else {
        newTelefono =
            '${newTelefono.substring(0, 4)} ${newTelefono.substring(4, 6)} ${newTelefono.substring(6)}';
      }
      newTelefono = '$prefijoWhatsApp $newTelefono'.trim();
    }

    return {'CodigoPais': codigoPais, 'numero': newTelefono};
  }
}
