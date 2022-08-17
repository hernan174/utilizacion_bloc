import 'package:flutter/material.dart';

import 'package:utilizacion_bloc/environment/environment.dart';
import 'package:utilizacion_bloc/models/telefono_model.dart';
import 'package:utilizacion_bloc/utils/responsive_wrapper_utils.dart';
import 'package:utilizacion_bloc/widgets/textfield_widget.dart';

class TextfieldTelefonoWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;

  final String labelTitulo;
  final String valorDefecto;
  final bool? mostrarAyuda;
  final double? maxWidth;
  final Function()? onSubmitted;
  const TextfieldTelefonoWidget({
    Key? key,
    required this.onChanged,
    this.labelTitulo = '',
    this.mostrarAyuda,
    this.maxWidth,
    this.onSubmitted,
    required this.valorDefecto,
  }) : super(key: key);

  @override
  State<TextfieldTelefonoWidget> createState() =>
      _TextfieldTelefonoWidgetState();
}

class _TextfieldTelefonoWidgetState extends State<TextfieldTelefonoWidget> {
  String codigoPais = '54';
  late TextEditingController controller;
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> telefono =
        TelefonoModel.telefonoToView(widget.valorDefecto);
    controller = TextEditingController(text: telefono['numero']);

    setState(() {});
    if (telefono['CodigoPais']!.isNotEmpty) {
      codigoPais = telefono['CodigoPais'];
    }
    widget.onChanged.call(codigoPais);
    widget.onChanged.call(TelefonoModel.numeroTelefonoToSafe(
        codigoPais: codigoPais, numero: controller.text));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ComboBanderasWidget(
          desactivarCampo: false,
          alto: context.determinarParaPantalla(desktop: 43, phone: 36),
          ancho: context.determinarParaPantalla(desktop: 55, phone: 50),
          opciones: Environment.lstCodigoPais,
          valorDefecto: codigoPais,
          onSeleccionoOpcion: (value) {
            codigoPais = value;

            widget.onChanged.call(TelefonoModel.numeroTelefonoToSafe(
                codigoPais: codigoPais, numero: controller.text));
          },
        ),
        const SizedBox(width: 5),
        Flexible(
          child: TextfieldModelWidget.telefono(
            ontap: () {
              // context.read<NotificacionesBloc>().add(OnNuevOverlayEvent(
              //     const Notificacion(
              //         titulo: 'Telefono',
              //         descripcion: 'Numero de telefono sin 0 ni 15')));
            },
            maxWidth: widget.maxWidth,
            ayudaIcon: widget.mostrarAyuda,
            labelTitulo: widget.labelTitulo,
            hintText: widget.labelTitulo,
            controller: controller,
            onSubmitted: (value) => widget.onSubmitted?.call(),
            onChanged: (value) {
              controller.text =
                  TelefonoModel.telefonoToView('$codigoPais$value')['numero'];
              controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length));
              widget.onChanged.call(TelefonoModel.numeroTelefonoToSafe(
                  codigoPais: codigoPais, numero: value));
            },
          ),
        ),
      ],
    );
  }
}

class ComboBanderasWidget extends StatefulWidget {
  final Map<String, String> opciones;
  final String? valorDefecto;
  final ValueChanged<String> onSeleccionoOpcion;

  final double ancho;
  final double alto;
  final bool desactivarCampo;
  const ComboBanderasWidget(
      {Key? key,
      required this.opciones,
      this.valorDefecto,
      required this.onSeleccionoOpcion,
      required this.ancho,
      required this.alto,
      this.desactivarCampo = false})
      : super(key: key);

  @override
  ComboWidgetState createState() => ComboWidgetState();
}

class ComboWidgetState extends State<ComboBanderasWidget> {
  dynamic valorSeleccionado;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    valorSeleccionado = widget.valorDefecto;
    return AbsorbPointer(
      absorbing: widget.desactivarCampo,
      child: SizedBox(
        height: widget.alto,
        width: widget.ancho,
        child: DropdownButtonFormField<String>(
          iconSize: 0.1,
          elevation: 10,
          isExpanded: true,
          borderRadius: BorderRadius.circular(5),
          style: const TextStyle(color: Colors.black54),
          decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(3),
                  borderSide: BorderSide(
                      width: 1, color: Theme.of(context).primaryColor)),
              contentPadding: EdgeInsets.only(
                  left: context.determinarParaPantalla(desktop: 3, phone: 1),
                  bottom:
                      context.determinarParaPantalla(desktop: 25, phone: 8))),
          value: valorSeleccionado,
          onChanged: (value) {
            setState(() {
              valorSeleccionado = value;
              widget.onSeleccionoOpcion.call(value!);
            });
          },
          items: widget.opciones.entries
              .map<DropdownMenuItem<String>>((e) => DropdownMenuItem<String>(
                    alignment: Alignment.centerLeft,
                    value: e.key,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                            height: 15, width: 15, child: Image.asset(e.value)),
                        Text(e.key),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
