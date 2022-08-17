part of 'persona_bloc.dart';

class PersonaState extends Equatable {
  final bool isWorking;
  final String error;
  final String campoError;
  final String msjStatus;
  final String accion;
  final PersonaModel persona;
  final List<PersonaModel> lstPersonas;

  PersonaState(
      {this.isWorking = false,
      this.error = '',
      this.campoError = '',
      this.msjStatus = '',
      this.accion = '',
      PersonaModel? persona,
      List<PersonaModel>? lstPersonas})
      : persona = persona ?? const PersonaModel(),
        lstPersonas = lstPersonas ?? [];

  PersonaState copyWith(
          {bool? isWorking,
          String? error,
          String? campoError,
          String? msjStatus,
          String? accion,
          PersonaModel? persona,
          List<PersonaModel>? lstPersonas}) =>
      PersonaState(
          isWorking: isWorking ?? this.isWorking,
          error: error ?? this.error,
          campoError: campoError ?? this.campoError,
          msjStatus: msjStatus ?? this.msjStatus,
          accion: accion ?? this.accion,
          persona: persona ?? this.persona,
          lstPersonas: lstPersonas ?? this.lstPersonas);

  @override
  List<Object> get props =>
      [isWorking, error, campoError, msjStatus, accion, persona, lstPersonas];
}
