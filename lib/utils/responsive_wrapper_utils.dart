import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

///Extencion que permite devolver el valor que se haya espeficicado para cada tamaño de pantalla.
///Los tamaños de pantalla son definidos en el main en el [ResponsiveWrapper.builder]
extension ResponsiveWrapperUtil on BuildContext {
  ///`T` Puede ser un cualquier tipo de dato por ejemplo: [double] si se quiere dar un ancho o alto a un widget
  ///o tamaño de fuente dependiendo las dimenciones de la pantalla. [bool] si se desea mostrar un widget unicamente
  ///en algun tamaño de pantalla especifico. [Alignment] Si se desea alinear el contenido en diferentes posiciones 
  ///de acuerdo el tamaño, etc.
  ///`desktop` es el unico valor obligatorio. si no se proporciona ningun valor para las demas propiedades se utilizara
  ///[desktop] por defecto
  T determinarParaPantalla<T>({
    required T desktop,
    T? tablet,
    T? mobile,
    T? phone,
  }) {
    T defecto = desktop;
    ///Cuando sea telefono verifica si es null intentara tomar el valor de la propiedad que le siga
    if (ResponsiveWrapper.of(this).isPhone) {
      return phone ?? mobile ?? tablet ?? desktop;
    }
    if (ResponsiveWrapper.of(this).isMobile) {
      return mobile ?? tablet ?? desktop;
    }
    if (ResponsiveWrapper.of(this).isTablet) {
      return tablet ?? desktop;
    }
    if (ResponsiveWrapper.of(this).isDesktop) {
      return desktop;
    }

    return defecto;
  }
}
