import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:utilizacion_bloc/utils/responsive_wrapper_utils.dart';

class TextfieldModelWidget extends StatelessWidget {
  const TextfieldModelWidget(
      {super.key,
      required this.controller,
      required this.labelTitulo,
      required this.obscureText,
      required this.decoration,
      this.maxWidth,
      this.onChanged,
      this.margin,
      this.msjError,
      required this.desactivarCampo,
      this.onSubmitted,
      this.textInputAction,
      this.hintText,
      this.focusNode,
      this.inputFormatters,
      this.maxLength});
  final TextEditingController? controller;
  final String labelTitulo;
  final String? hintText;
  final bool obscureText;
  final InputDecoration decoration;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final EdgeInsets? margin;
  final double? maxWidth;
  final String? msjError;
  final bool desactivarCampo;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: desactivarCampo,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? MediaQuery.of(context).size.width,
        ),
        margin: margin,
        height: context.determinarParaPantalla(phone: 36, desktop: 43),
        color: desactivarCampo ? Colors.grey[300] : Colors.transparent,
        child: TextFormField(
            textInputAction: textInputAction,
            autofocus: false,
            maxLength: maxLength,
            controller: controller,
            obscureText: obscureText,
            inputFormatters: inputFormatters,
            focusNode: focusNode,
            style: Theme.of(context).textTheme.headline4!.copyWith(
                color: desactivarCampo ? Colors.white : null,
                fontSize:
                    context.determinarParaPantalla(desktop: 15, phone: 11)),
            textCapitalization: TextCapitalization.sentences,
            onChanged: onChanged,
            onFieldSubmitted: onSubmitted,
            decoration: decoration.copyWith(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide(width: desactivarCampo ? 0 : 0.1)),
                contentPadding: EdgeInsets.only(
                    left: context.determinarParaPantalla(desktop: 10, phone: 5),
                    bottom:
                        context.determinarParaPantalla(desktop: 15, phone: 0)),
                //label: TextModelWidget.texto(texto: labelTitulo),
                labelStyle: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Colors.black54,
                    fontSize:
                        context.determinarParaPantalla (desktop: 15, phone: 13)),
                labelText: labelTitulo,
                counterText: '',
                hintText: hintText)),
      ),
    );
  }

  factory TextfieldModelWidget.contrasena(
      {Key key,
      required Function() ontap,
      TextEditingController? controller,
      required String labelTitulo,
      bool obscureText,
      Function(String)? onChanged,
      EdgeInsets? margin,
      InputDecoration decoration,
      double? maxWidth,
      String? msjError,
      bool? desactivarCampo,
      Function(String)? onSubmitted,
      TextInputAction? textInputAction,
      String? hintText}) = _TextfieldContrasenaModelWidget;

  factory TextfieldModelWidget.estandar(
      {Key key,
      Function() ontap,
      TextEditingController? controller,
      required String labelTitulo,
      bool obscureText,
      Function(String)? onChanged,
      Function(String)? onSubmitted,
      EdgeInsets? margin,
      bool? ayudaIcon,
      IconData? suffixIcon,
      InputDecoration decoration,
      double? maxWidth,
      bool? desactivarCampo,
      TextInputAction? textInputAction,
      String? msjError,
      FocusNode? focusNode,
      String? hintText}) = _TextfieldEstandarModelWidget;
  factory TextfieldModelWidget.telefono(
      {Key key,
      Function() ontap,
      TextEditingController? controller,
      required String labelTitulo,
      bool obscureText,
      Function(String)? onChanged,
      Function(String)? onSubmitted,
      EdgeInsets? margin,
      bool? ayudaIcon,
      IconData? suffixIcon,
      InputDecoration decoration,
      double? maxWidth,
      bool? desactivarCampo,
      TextInputAction? textInputAction,
      String? msjError,
      FocusNode? focusNode,
      List<TextInputFormatter>? inputFormatters,
      int? maxLength,
      String? hintText}) = _TextfieldTelefonoModelWidget;
}

class _TextfieldContrasenaModelWidget extends TextfieldModelWidget {
  final Function() ontap;
  _TextfieldContrasenaModelWidget(
      {super.key,
      required this.ontap,
      super.controller,
      required super.labelTitulo,
      super.onChanged,
      super.onSubmitted,
      super.obscureText = true,
      InputDecoration? decoration,
      super.maxWidth,
      EdgeInsets? margin,
      String? msjError,
      bool? desactivarCampo,
      String? hintText,
      TextInputAction? textInputAction = TextInputAction.next})
      : super(
            decoration: decoration ??
                InputDecoration(
                    errorText: msjError,
                    suffixIcon: InkWell(
                      child: GestureDetector(
                          onTap: ontap,
                          child: (obscureText)
                              ? const Icon(
                                  FontAwesomeIcons.eye,
                                  size: 14,
                                )
                              : const Icon(
                                  FontAwesomeIcons.eyeSlash,
                                  size: 14,
                                )),
                    )),
            margin: margin,
            textInputAction: textInputAction,
            desactivarCampo: desactivarCampo ?? false,
            hintText: hintText);
}

class _TextfieldEstandarModelWidget extends TextfieldModelWidget {
  final Function()? ontap;
  _TextfieldEstandarModelWidget(
      {super.key,
      super.controller,
      this.ontap,
      required super.labelTitulo,
      super.onChanged,
      super.obscureText = false,
      InputDecoration? decoration,
      bool? ayudaIcon,
      IconData? suffixIcon = Icons.lightbulb_outline,
      EdgeInsets? margin,
      super.maxWidth,
      String? msjError,
      bool? desactivarCampo,
      super.onSubmitted,
      FocusNode? focusNode,
      TextInputAction? textInputAction = TextInputAction.next,
      String? hintText})
      : super(
            decoration: decoration ??
                InputDecoration(
                  errorText: msjError,
                  suffixIcon: Visibility(
                    visible: ayudaIcon ?? false,
                    child: GestureDetector(
                      onTap: ontap,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Icon(
                          suffixIcon,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ),
            margin: margin,
            textInputAction: textInputAction,
            desactivarCampo: desactivarCampo ?? false,
            hintText: hintText,
            focusNode: focusNode);
}

class _TextfieldTelefonoModelWidget extends TextfieldModelWidget {
  final Function()? ontap;
  _TextfieldTelefonoModelWidget(
      {super.key,
      super.controller,
      this.ontap,
      required super.labelTitulo,
      super.onChanged,
      super.obscureText = false,
      InputDecoration? decoration,
      bool? ayudaIcon,
      IconData? suffixIcon = Icons.lightbulb_outline,
      EdgeInsets? margin,
      super.maxWidth,
      String? msjError,
      bool? desactivarCampo,
      super.onSubmitted,
      FocusNode? focusNode,
      TextInputAction? textInputAction = TextInputAction.next,
      List<TextInputFormatter>? inputFormatters,
      int? maxLength,
      String? hintText})
      : super(
            decoration: decoration ??
                InputDecoration(
                  errorText: msjError,
                  suffixIcon: Visibility(
                    visible: ayudaIcon ?? false,
                    child: GestureDetector(
                      onTap: ontap,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Icon(
                          suffixIcon,
                          size: 14,
                        ),
                      ),
                    ),
                  ),
                ),
            margin: margin,
            textInputAction: textInputAction,
            desactivarCampo: desactivarCampo ?? false,
            hintText: hintText,
            focusNode: focusNode,
            inputFormatters:
                inputFormatters ?? [FilteringTextInputFormatter.digitsOnly],
            maxLength: maxLength ?? 13);
}
