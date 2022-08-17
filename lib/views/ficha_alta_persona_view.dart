import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utilizacion_bloc/bloc/persona/persona_bloc.dart';
import 'package:utilizacion_bloc/environment/environment.dart';
import 'package:utilizacion_bloc/models/persona_model.dart';
import 'package:utilizacion_bloc/widgets/selector_fecha_widget.dart';
import 'package:utilizacion_bloc/widgets/textfield_telefono_widget.dart';
import 'package:utilizacion_bloc/widgets/textfield_widget.dart';

///Forma en la cual se va a trabajar con las fichas para edicion de registro.
///Se debe respetar este modelo siempre que sea posible.
///[Este es un modelo para un alta] Se debe completar el formulario y dar al boton guardar para disparar
///la accion de valida y guardar.
///[EXISTE OTRO MODELO PARA REALIZAR ACTUALIZACIONES DE CAMPOS EN EL MODIFICACION]
class FichaAltaPersonaView extends StatefulWidget {
  const FichaAltaPersonaView({Key? key}) : super(key: key);

  @override
  State<FichaAltaPersonaView> createState() => _FichaAltaPersonaViewState();
}

class _FichaAltaPersonaViewState extends State<FichaAltaPersonaView> {
  ///Es esta variable se almacena el modelo de la persona con el que se va a trabajar en la visual
  late PersonaModel personaModel;

  @override
  void initState() {
    ///Esto es para cargar el modelo de la persona que este en el state e inicializar la variable de la vista
    personaModel = context.read<PersonaBloc>().state.persona;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 400,
        height: 250,
        child: BlocConsumer<PersonaBloc, PersonaState>(
          listenWhen: (previous, current) => !current.isWorking,
          listener: (context, state) {
            if (state.error.isEmpty) {
              ///Si no existe errores
              if (state.accion == Environment.blocOnValidarPersona) {
                context.read<PersonaBloc>().add(const OnGuardarPersona());
              }
              if (state.accion == Environment.blocOnGuardarPersona) {
                log('Se guardo la persona');
                Navigator.of(context).pop();
              }
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                ///Al modelo actual se pasa a json para trabajar con los datos del objeto
                ...personaModel
                    .toJson()

                    ///Se mapea el objeto a un widget
                    .entries
                    .map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: _ItemFormulario(
                            titulo: item.key,
                            valor: item.value,
                            onChanged: (value) {
                              ///Se actualiza el modelo de la visual con el cambio que se haya realizado
                              ///No se realiza un settState porque no es necesario actualizar nada
                              personaModel = personaModel

                                  ///al usar el [copyWith] del modelo mantiene los otros datos y que tiene
                                  ///y solo actualiza el campo que se este modificando

                                  .copyWith(data: {item.key: value});
                            },
                          ),
                        )),

                ///Acciones de guardar y cancelar
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar')),
                    const SizedBox(width: 15),
                    ElevatedButton(
                        onPressed: () {
                          context.read<PersonaBloc>().add(OnValidarPersona(
                              persona: personaModel, pagina: 0));
                        },
                        child: const Text('Guardar')),
                  ],
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ItemFormulario extends StatelessWidget {
  const _ItemFormulario({
    Key? key,
    required this.titulo,
    required this.valor,
    required this.onChanged,
  }) : super(key: key);
  final String titulo;
  final String valor;
  final Function(String) onChanged;
  @override
  Widget build(BuildContext context) {
    ///Se pone un row unicamente para poder poner un if y saber de que campo se trata para poner un widget u otro
    return Row(
      children: [
        ///Cuando sea numero de telefono muestra el widget de telefono
        if (titulo == PersonaModel.titulosFormulario.keys.elementAt(1))
          TextfieldTelefonoWidget(
            maxWidth: 290,
            valorDefecto: valor,
            onChanged: (value) {
              ///Se pasa al padre lo que se haya modificado
              onChanged.call(value);
            },
          )
        else if (titulo == PersonaModel.titulosFormulario.keys.elementAt(2))
          SelectorFechaWidget(
            maxWidth: 350,
            onFechaSeleccionada: (value) {
              ///Se pasa al padre lo que se haya modificado
              onChanged.call(value);
            },
            fechaInicial: valor,
            titulo: titulo,
          )
        else
          TextfieldModelWidget.estandar(
            controller: TextEditingController(text: valor),
            maxWidth: 350,

            ///Para el titulo se obtiene el valor del mapa que corresponda a la clave del modelo de la clase
            labelTitulo: PersonaModel.titulosFormulario[titulo]!,
            onChanged: (value) {
              ///Se pasa al padre lo que se haya modificado
              onChanged.call(value);
            },
          )
      ],
    );
  }
}
