import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:utilizacion_bloc/bloc/persona/persona_bloc.dart';
import 'package:utilizacion_bloc/environment/environment.dart';

class AdminPersonaView extends StatelessWidget {
  const AdminPersonaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado'),
      ),
      body: BlocConsumer<PersonaBloc, PersonaState>(
        ///Se llama al listener unicamente cuando isWorking este en falso
        listenWhen: (previous, current) => !current.isWorking,
        listener: (context, state) {
          if (state.error.isEmpty) {
            ///Si la accion es modifica y error esta en blanco quiere decir que se cargo el item seleccionado al state
            ///y se procede a navegar
            if (state.accion == Environment.blocOnNuevaPersona ||
                state.accion == Environment.blocOnModificarPersona) {
              Navigator.pushNamed(context, 'alta');
            }
          } else {
            log('ERROR>>>>>>>> ${state.error}');
          }
        },
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            children: state.lstPersonas
                .map((e) => InkWell(
                      onTap: () {
                        ///Para editar un item siempre se llama al onModifica y se navega en el listener cuando la
                        ///accion sea modifica y no tenga error. [No realizar la navegacion en este punto] esperar
                        ///siempre por el bloc
                        context
                            .read<PersonaBloc>()
                            .add(OnModificarPersona(idPersona: e.id));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                            '${e.id} ${e.nombre} - ${e.fechaNacimiento} - ${e.telefono}'),
                      ),
                    ))
                .toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        context.read<PersonaBloc>().add(const OnNuevaPersona());
      }),
    );
  }
}
