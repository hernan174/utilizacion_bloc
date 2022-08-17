part of 'persona_bloc.dart';

abstract class PersonaEvent extends Equatable {
  const PersonaEvent();

  @override
  List<Object> get props => [];
}

/// Este evento inicializa la propiedad [persona] que depende de
/// PersonaState
/// [parametros] - No requiereServidor
class OnNuevaPersona extends PersonaEvent {
  const OnNuevaPersona();
}

/// Este evento lee del Servidor los datos de la Persona y los carga en la
/// propiedad [persona] de PersonaState
/// [parametros] - requiere [idPersona]
/// `idPersona` valor que identifica el id de la Persona
class OnModificarPersona extends PersonaEvent {
  final String idPersona;
  const OnModificarPersona({required this.idPersona});
}

/// Este evento valida toda la Informacion de la persona y los datos que
/// se encuentran Ok los carga en la propidad [persona] de PersonaState
/// [parametros] - requiere una clase de tipo [PersonaModel]
/// `persona` clase q contiene los datos de la persona
class OnValidarPersona extends PersonaEvent {
  final PersonaModel persona;
  final int pagina;
  const OnValidarPersona({required this.persona, required this.pagina});
}

/// Este evento toma [persona] de PersonaState y lo guarda en el
/// Servidor
/// [parametros] - No requiere
class OnGuardarPersona extends PersonaEvent {
  const OnGuardarPersona();
}

/// Este evento carga el valor que recibe como paramentro dentro del modelo
/// Persona que se encuentra en PersonaState , valida Persona
/// y lo Guarda
/// [parametros] - requiere [data]
/// `data` es un mapa donde el key es el nombre del campo y en el value del mapa
/// van los valores que se le asignan a los campos
class OnActualizaPersona extends PersonaEvent {
  final Map<String, dynamic> data;
  const OnActualizaPersona({required this.data});
}

/// Este evento obtiene toda la lista de Personaes y los carga en lstPersonaes
class OnObtenerlstPersona extends PersonaEvent {
  const OnObtenerlstPersona();
}
