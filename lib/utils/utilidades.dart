import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class Utilidades {
  ///Esta funcion compara 2 mapas generando uno nuevo con los datos que
  ///fueron modificados o agregados en el mapaActualizado
  ///como paramentro opcional recive keyExcluir que se si indica el key
  ///del mapaActualizado no es tenido encuenta
  ///se utiliza la libreria [collection] para poder utilizar la funcion
  ///ListEquality y comprar 2 listas
  static Map<String, dynamic> newMap(
      {required Map<String, dynamic> mapaOriginal,
      required Map<String, dynamic> mapaActualizado,
      List<String>? lstKeyExcluir}) {
    try {
      final Map<String, dynamic> newMap = {};
      mapaActualizado.forEach((key, value) {
        if (lstKeyExcluir == null || !lstKeyExcluir.contains(key)) {
          bool iguales = false;
          if (mapaOriginal.containsKey(key)) {
            if (value is List) {
              iguales = const ListEquality().equals(mapaOriginal[key], value);
            } else {
              iguales = mapaOriginal[key] == value;
            }
          }
          if (!iguales) {
            newMap.putIfAbsent(key, () => value);
          }
        }
      });
      return newMap;
    } catch (e) {
      return {};
    }
  }

  static DateTime verificarFechaValida(String date, String formatoFecha) {
    if (DateTime.tryParse(date.replaceAll('/', '')) == null) {
      return DateTime.now();
    }
    try {
      DateTime fecha = DateFormat(formatoFecha).parse(date);

      return fecha;
    } catch (e) {
      return DateTime.now();
    }
  }

  static DateTime obtenerFechaMaxima(
      {required DateTime fecha1, required DateTime fecha2}) {
    try {
      return fecha1.isAfter(fecha2) ? fecha2 : fecha1;
    } catch (e) {
      return DateTime.now();
    }
  }
}
