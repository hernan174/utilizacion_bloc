class RegExpUtils {
  ///Valida Sexo los Valores Permitidos son [M= Masculio, F= Femenino, X= No Binario]
  ///[sexo] Sexo a validar devuelve true si se ingreso (M/F o X) o false en caso contrario
  static bool validaSexo(String? sexo) {
    if (sexo == null) return false;
    return _patron(_Patrones._patronSexo).hasMatch(sexo);
  }

  ///Valida Email
  ///[email] Email a validar devuelve true si es un mail valio o false si no lo es
  static bool validaEmail(String? email) {
    if (email == null || email.isEmpty) return false;
    return _patron(_Patrones._patronEmail).hasMatch(email);
  }

  ///Valida una fecha en base a una exprecion regular
  ///Formato de fecha valido dd/MM/yyyy.
  ///El patron valida años bisiestos
  ///[fecha] fecha a validar devuelve true si es una fecha valida y false si no es valida
  static bool validarFecha(String? fecha) {
    if (fecha == null) return false;
    return _patron(_Patrones._patronFecha).hasMatch(fecha);
  }

  ///Valida una hora en base a una exprecion regular
  ///Formato de hora valido HH:MM.
  ///[hora] hora a validar devuelve true si es la hora es valida y false si no es valida
  static bool validarHora(String? hora) {
    if (hora == null) return false;
    return _patron(_Patrones._patronHora).hasMatch(hora);
  }

  ///Valida una ip es base a una exprecion regular
  ///Formato de ip valido 1.0.0.0 hasta 255.255.255.255
  ///[direccionIp] valida un string que represente una direccion ip. Si es una ip valida devuelve true si no false
  static bool validaDireccionIp(String? direccionIp) {
    if (direccionIp == null) return false;
    return _patron(_Patrones._patronIp).hasMatch(direccionIp);
  }

  ///Valida una cadena que sea un numero.
  ///No permite numeros decimales unicamente enteros positivos.
  ///[cadena] valida un string que represente un numero. Si es un numero valida devuelve true si no false
  static bool validaNumero(String? cadena) {
    if (cadena == null || cadena.trim().isEmpty) return false;
    return _patron(_Patrones._patronUnicamenteNumero).hasMatch(cadena);
  }

  ///Valida una cadena que contenga unicamente letras sin caracteres especiales
  ///No permite letras con acentos o signos especiales
  ///[cadena] Si unicamente posee letras devuelve true si no false
  static bool validaLetras(String? cadena) {
    if (cadena == null) return false;
    return _patron(_Patrones._patronUnicamenteLetras).hasMatch(cadena);
  }

  ///Valida una cadena que corresponda a un documento valido
  ///No permite numeros de documento menor a 1 millon ni superior a 100 millones
  static bool validaNroDocumento(String? dni) {
    if (dni == null) return false;
    return _patron(_Patrones._patronNroDocumento).hasMatch(dni) &&
        validaLongitudMinMax(7, 9, dni);
  }

  ///Valida una cadena para no permitir agregar mas de 3 caracteres consecutivos iguales
  static bool validaCaracterConsecutivo(String? palabra) {
    if (palabra == null || palabra.isEmpty) return false;
    return !_patron(_Patrones._patronCaracterConsecutivo).hasMatch(palabra);
  }

  ///Valida que la cadena tenga una longitud que se encuentre dentro del rango minimo y maximo
  ///[min] La cantidad minima de caracteres.
  ///[max] La cantidad maxima de caracteres. Si es null no tiene un limite
  static bool validaLongitudMinMax(int? min, int? max, String? cadena) {
    if (min == null || cadena == null) return false;

    if (max == null) return _patron("^.{$min,}").hasMatch(cadena);
    return _patron("^[a-zA-Z 0-9ÁÉÍÓÚáéíóúñÑ,.]{$min,$max}\$").hasMatch(cadena);
  }

  ///Valida una contraseña si es valida
  ///Existe 3 niveles de seguridad
  ///Bajo: Unicamente debe poseer un minimo de 6 caracteres
  ///Medio: Debe posee minimo 8 caracteres y poseer letras y numeros
  ///Alto: Debe poseeer minimo 8 caracteres y posee letras (1 minuscula y 1 mayuscula), numeros y caracter especial
  static bool validaPassword(
      NivelSeguridadPassword? nivelSeguridad, String? password) {
    if (nivelSeguridad == null || password == null || password.isEmpty) {
      return false;
    }
    switch (nivelSeguridad) {
      case NivelSeguridadPassword.bajo:
        return _patron(_Patrones._patronPasswordNivelBajo).hasMatch(password);
      case NivelSeguridadPassword.medio:
        return _patron(_Patrones._patronPasswordNivelMedio).hasMatch(password);
      default:
        return _patron(_Patrones._patronPasswordNivelAlto).hasMatch(password);
    }
  }

  ///Utilidad para verificar si un texto posee una palabra o caracter.
  ///[posicion] Indica si debe iniciar, terminar o contener lo que posea [palabras].
  ///[palabras] Es un arreglo de string es util para verificar varias parabras en un solo texto.
  ///Util para las acciones de los bloc cuando se quiera verificar que sea un evento es especifico o varios
  ///[texto] es donde se va a realizar la busqueda de [palabras]
  static bool verificarSiContiene(
      PosicionTexto? posicion, List<String>? palabras, String? texto) {
    if (posicion == null ||
        texto == null ||
        texto.trim().isEmpty ||
        palabras == null ||
        palabras.isEmpty) return false;
    bool contiene = false;
    for (String? palabra in palabras) {
      //Si el valor actual del arreglo es un texto en blanco no lo valida

      if (palabra != null && palabra.trim().isNotEmpty) {
        switch (posicion) {
          case PosicionTexto.inicia:
            contiene = _patron("^\\$palabra").hasMatch(texto);
            break;
          case PosicionTexto.termina:
            contiene = _patron("$palabra\$").hasMatch(texto);
            break;
          default:
            contiene = _patron(palabra).hasMatch(texto);
            break;
        }
      }
      //Si encuentra una coincidencia deja de buscar
      if (contiene) break;
    }

    return contiene;
  }

  ///Verifica que dos grupo de caracteres sea exactamente iguales
  ///Si alguno de los 2 valores es null o esta en blanco devuelve false
  static bool verificarIgualdad(String? texto1, String? texto2) {
    if (texto1 == null ||
        texto1.trim().isEmpty ||
        texto2 == null ||
        texto2.trim().isEmpty) return false;

    return _patron(".*$texto1.*").hasMatch(texto2);
  }

  ///Validacion de patente
  ///Valida que sea un formate de patenet valida.
  ///Es valido para patentes con formato ABC123 y A123BCD
  static bool validarPatente(String? patente) {
    if (patente == null) return false;
    return _patron(_Patrones._patronPatenteModeloAntiguo).hasMatch(patente) ||
        _patron(_Patrones._patronPatenteModeloNuevo).hasMatch(patente);
  }

  static RegExp _patron(String patron) {
    return RegExp(patron, caseSensitive: true, multiLine: false);
  }
}

///Niveles de seguridad para [validaPassword]
enum NivelSeguridadPassword { bajo, medio, alto }

///Tipo de busquedas para [verificarSiContiene]
enum PosicionTexto { inicia, termina, contiene }

class _Patrones {
  ///Expresion regular para fecha
  static const String _patronFecha =
      r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579][26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$';

  ///Expresion regular para Hora HH:MM
  static const String _patronHora = r'^(0[0-9]|1[0-9]|2[0-4]):[0-5][0-9]$';

  ///Exprecion regular para direccion IP
  static const String _patronIp =
      r'^(?!0)(?!.*\.$)((1?\d?\d|25[0-5]|2[0-4]\d)(\.|$)){4}$';

  ///Expresion regular para validar si todos los caracteres son numeros
  static const String _patronUnicamenteNumero = r'^([0-9])*$';

  ///Expresion regular para validar si todos los caracteres son letras
  static const String _patronUnicamenteLetras =
      r'^[A-Za-zÁÉÍÓÚáéíóúñÑÄËÏÖÜäëïöü ]+$';

  ///Expresion regular para validar si se trata de un documento valido
  static const String _patronNroDocumento =
      r'(100000[0-9]|10000[1-9][0-9]|1000[1-9][0-9]{2}|100[1-9][0-9]{3}|10[1-9][0-9]{4}|1[1-9][0-9]{5}|[2-9][0-9]{6}|[1-9][0-9]{7})';

  ///Valida que no se repitan 3 veces el mismo caracter de forma consecutiva
  static const String _patronCaracterConsecutivo =
      r'([a-zA-Z0-9ÁÉÍÓÚáéíóúñÑ ])\1\1+';

  ///Seguridad basica unicamente 6 caracteres como minimo
  static const String _patronPasswordNivelBajo = r'^\w{6,}$';

  ///Seguridad media 8 caracteres como minimo y debe poseer letras y numeros
  static const String _patronPasswordNivelMedio =
      r'(?=.*[a-zA-Z])(?=.*[0-9]).{8,}$';

  ///Seguridad alta 8 caracteres como minimo y debe poseer letras mayusculas, minusculas, numeros y caracteres especiales
  static const String _patronPasswordNivelAlto =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*_=+-]).{8,}$';

  ///Patron para patente modelo antiguo admite ABC123
  static const String _patronPatenteModeloAntiguo = r'[A-Z]{3}[0-9]{3}';

  ///Patron para patente modelo nuevo admite AC123BC
  static const String _patronPatenteModeloNuevo = r'[A-Z]{2}[0-9]{3}[A-Z]{2}';

  ///Patron para validar Emails
  static const String _patronEmail =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  ///Patron para validar Sexo (F/M/X);
  static const String _patronSexo = r'[MFX]{1}';
}
