import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utilizacion_bloc/environment/environment.dart';
import 'package:utilizacion_bloc/models/persona_model.dart';
import 'package:utilizacion_bloc/models/telefono_model.dart';
import 'package:utilizacion_bloc/utils/reg_exp_utils.dart';

part 'persona_event.dart';
part 'persona_state.dart';

class PersonaBloc extends Bloc<PersonaEvent, PersonaState> {
  PersonaBloc() : super(PersonaState()) {
    on<OnNuevaPersona>(_onNuevaPersona);
    on<OnModificarPersona>(_onModificarPersona);
    on<OnValidarPersona>(_onValidarPersona);
    on<OnGuardarPersona>(_onGuardarPersona);
    on<OnActualizaPersona>(_onActualizaPersona);
    on<OnObtenerlstPersona>(_onObtenerlstPersona);
  }

  Future<void> _onNuevaPersona(OnNuevaPersona event, Emitter emit) async {
    emit(state.copyWith(
        persona: const PersonaModel(),
        error: '',
        accion: Environment.blocOnNuevaPersona));
  }

  Future<void> _onModificarPersona(
      OnModificarPersona event, Emitter emit) async {
    try {
      String error = '';
      PersonaModel persona = const PersonaModel();

      persona =
          state.lstPersonas.firstWhere((item) => item.id == event.idPersona);

      emit(state.copyWith(
          isWorking: false,
          error: error,
          msjStatus: '',
          persona: persona,
          accion: Environment.blocOnModificarPersona));
    } catch (e) {
      emit(state.copyWith(
          isWorking: false,
          error: e.toString(),
          accion: Environment.blocOnModificarPersona));
    }
  }

  Future<void> _onValidarPersona(OnValidarPersona event, Emitter emit) async {
    try {
      emit(state.copyWith(
          isWorking: true,
          error: '',
          accion: Environment.blocOnValidarPersona));

      final validacion = await validaPersona(event.persona, event.pagina);

      emit(state.copyWith(
          isWorking: false,
          error: validacion['error'],
          msjStatus: '',
          campoError: validacion['campoError'],
          persona: validacion['persona'],
          accion: Environment.blocOnValidarPersona));
    } catch (e) {
      emit(state.copyWith(
          isWorking: false,
          error: e.toString(),
          accion: Environment.blocOnValidarPersona));
    }
  }

  Future<Map<String, dynamic>> validaPersona(
      PersonaModel persona, int pagina) async {
    try {
      String error = '', campoError = '';

      PersonaModel newPersona = state.persona;

      if (pagina == 0 || pagina >= 1) {
        if (persona.nombre.isEmpty) {
          error = 'Falta Definir el nombre';
          campoError = 'nombre';
        } else {
          newPersona =
              newPersona.copyWith(data: {'nombre': persona.nombre.trim()});
        }

        if (error.isEmpty) {
          final telefono =
              persona.telefono.replaceAll(RegExp(r'[+ ]{1}'), '').trim();
          if (!RegExpUtils.validaNumero(telefono)) {
            error = 'Telefono invalido';
            campoError = 'telefono';
          }
          if (error.isEmpty) {
            final numtel = TelefonoModel.telefonoToView(telefono);
            if (!numtel['numero'].startsWith('9')) {
              error =
                  'Telefono invalido para WhatsApp requiere el 9 despues del Codigo del Pais';
              campoError = 'telefono';
            }
            if (error.isEmpty) {}
          }

          if (error.isEmpty) {
            newPersona = newPersona.copyWith(data: {'telefono': telefono});
          }
        }
        if (error.isEmpty) {
          newPersona = newPersona
              .copyWith(data: {'fechaNacimiento': persona.fechaNacimiento});
        }
      }
      return {'error': error, 'campoError': campoError, 'persona': newPersona};
    } catch (e) {
      return {
        'error': e.toString(),
        'campoError': 'DEVELOPER',
        'persona': const PersonaModel()
      };
    }
  }

  Future<void> _onGuardarPersona(OnGuardarPersona event, Emitter emit) async {
    try {
      emit(state.copyWith(
          isWorking: true,
          error: '',
          msjStatus: '',
          accion: Environment.blocOnGuardarPersona));
      String error = '';
      String msjStatus = '';
      final validacion = await validaPersona(state.persona, 0);
      error = validacion['error'];
      PersonaModel persona = state.persona;
      List<PersonaModel> lstPersona = [...state.lstPersonas];
      if (error.isEmpty) {
        if (persona.id.isEmpty) {
          persona = persona.copyWith(id: (lstPersona.length + 1).toString());
          lstPersona.add(persona);
        } else {
          lstPersona = lstPersona.map((e) {
            if (e.id == persona.id) {
              return persona;
            } else {
              return e;
            }
          }).toList();
        }
      }

      emit(state.copyWith(
          isWorking: false,
          error: error,
          msjStatus: msjStatus,
          lstPersonas: lstPersona,
          persona: (error.isEmpty) ? persona : null,
          accion: Environment.blocOnGuardarPersona));
    } catch (e) {
      emit(state.copyWith(
          isWorking: false,
          error: e.toString(),
          accion: Environment.blocOnGuardarPersona));
    }
  }

  Future<void> _onActualizaPersona(
      OnActualizaPersona event, Emitter emit) async {
    try {
      emit(state.copyWith(
          isWorking: true,
          error: '',
          campoError: '',
          msjStatus: '',
          accion: Environment.blocOnActualizaPersona));
      String error = '';
      List<PersonaModel> lstPersona = [...state.lstPersonas];
      PersonaModel persona = const PersonaModel();
      final json = state.persona.toJson();
      event.data.forEach((key, value) {
        if (!json.containsKey(key)) {
          error = 'El Campo a Modificar es Inexistente';
        }
        if (value.isEmpty) {
          error = 'El Campo Valor esta Vacio';
        }
      });
      if (error.isEmpty) {
        event.data.forEach((key, value) {
          json[key] = value;
        });
        persona = persona.copyWith(
            id: state.persona.id,
            estado: state.persona.estado,
            dataOriginal: state.persona.dataOriginal,
            data: json);
      }
      if (error.isEmpty) {
        final validacion = await validaPersona(persona, 0);
        error = validacion['error'];
        persona = validacion['persona'];
      }

      if (error.isEmpty) {
        if (error.isEmpty) {
          lstPersona.add(persona);
        }
      }

      emit(state.copyWith(
          isWorking: false,
          error: error,
          lstPersonas: lstPersona,
          persona: (error.isEmpty) ? persona : null,
          accion: Environment.blocOnActualizaPersona));
    } catch (e) {
      emit(state.copyWith(
          isWorking: false,
          error: e.toString(),
          accion: Environment.blocOnActualizaPersona));
    }
  }

  Future<void> _onObtenerlstPersona(
      OnObtenerlstPersona event, Emitter emit) async {
    try {
      emit(state.copyWith(
          isWorking: true,
          error: '',
          persona: const PersonaModel(),
          lstPersonas: [],
          accion: Environment.blocOnObtenerlstPersona));

      String error = '';

      const List<PersonaModel> lstPersonas = [
        PersonaModel(
            id: '1',
            nombre: 'Hernan',
            fechaNacimiento: '04/01/1994',
            telefono: '5493751661222'),
        PersonaModel(
            id: '2',
            nombre: 'Federico',
            fechaNacimiento: '01/05/1990',
            telefono: '549376465243'),
        PersonaModel(
            id: '3',
            nombre: 'Daniel',
            fechaNacimiento: '01/07/1992',
            telefono: '549376466999')
      ];

      emit(state.copyWith(
          isWorking: false,
          error: error,
          lstPersonas: (error.isEmpty) ? lstPersonas : null,
          accion: Environment.blocOnObtenerlstPersona));
    } catch (e) {
      emit(state.copyWith(
          isWorking: false, accion: Environment.blocOnObtenerlstPersona));
    }
  }
}
