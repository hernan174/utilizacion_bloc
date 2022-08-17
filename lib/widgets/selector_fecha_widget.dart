import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:utilizacion_bloc/utils/responsive_wrapper_utils.dart';
import 'package:utilizacion_bloc/utils/utilidades.dart';
import 'package:utilizacion_bloc/widgets/textfield_widget.dart';

class SelectorFechaWidget extends StatefulWidget {
  final String fechaInicial;
  final ValueChanged<String> onFechaSeleccionada;
  final String titulo;
  final double? maxWidth;
  final DateTime? fechaMaxima;
  const SelectorFechaWidget(
      {Key? key,
      required this.onFechaSeleccionada,
      required this.fechaInicial,
      required this.titulo,
      this.maxWidth,
      this.fechaMaxima})
      : super(key: key);

  @override
  SelectorFechaWidgetState createState() => SelectorFechaWidgetState();
}

class SelectorFechaWidgetState extends State<SelectorFechaWidget> {
  String fechaSeleccionada = '';
  TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    fechaSeleccionada = widget.fechaInicial;
    controller.text = fechaSeleccionada;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.maxWidth,
      height: context.determinarParaPantalla(desktop: 37, phone: 30),
      child: Stack(
        alignment: Alignment.center,
        children: [
          TextfieldModelWidget.estandar(
            controller: controller,
            labelTitulo: widget.titulo,
            textInputAction: TextInputAction.done,
            onSubmitted: (value) {
              try {
                DateFormat('dd/MM/yyyy').parse(value);
              } catch (e) {
                // context.read<NotificacionesBloc>().add(OnNuevaNotificacionEvent(
                //     const Notificacion(
                //         descripcion: 'Fecha invalida',
                //         tipoNotificacion: TipoNotificacion.error)));
                log('Error fecha invalida');
              }
            },
          ),
          Positioned(
            right: 3,
            child: InkWell(
                onTap: () async {
                  await _mostrarSelectorFecha(context, 'dd/MM/yyyy');
                  widget.onFechaSeleccionada.call(fechaSeleccionada);
                  setState(() {
                    controller.text = fechaSeleccionada;
                  });
                },
                child: const Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.grey,
                )),
          )
        ],
      ),
    );
  }

  Future<void> _mostrarSelectorFecha(
      BuildContext context, String formatoFecha) async {
    DateTime? fecha = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendar,
      initialDate: Utilidades.obtenerFechaMaxima(
          fecha1:
              Utilidades.verificarFechaValida(fechaSeleccionada, formatoFecha),
          fecha2: widget.fechaMaxima ?? DateTime.now()),
      firstDate: DateTime(1900),
      lastDate: widget.fechaMaxima ?? DateTime.now(),
      locale: const Locale('es', 'ES'),
      fieldHintText: 'dd/MM/yyyy',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light()
                  .copyWith(primary: Theme.of(context).primaryColor)),
          child: child!,
        );
      },
    );
    if (mounted) {
      FocusScope.of(context).requestFocus(FocusNode());
      fechaSeleccionada = (fecha == null)
          ? fechaSeleccionada
          : DateFormat(formatoFecha).format(fecha);
    }
  }
}
