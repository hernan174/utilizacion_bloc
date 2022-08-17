import 'dart:convert';

import 'package:utilizacion_bloc/models/modelo_base.dart';
import 'package:utilizacion_bloc/models/modelo_base_cdm.dart';
import 'package:utilizacion_bloc/utils/utilidades.dart';

String personaModelToJson(PersonaModel data) => json.encode(data.toJson());

///Implementa la clase [ModeloBaseCdm] para poder utilizar el modelo generico de [CloudCdmBaseEvent]
class PersonaModel extends ModeloBase implements ModeloBaseCdm<PersonaModel> {
  @override
  final String id;
  @override
  final String estado;
  @override
  final String dataOriginal;

  final String nombre;
  final String telefono;
  final String fechaNacimiento;

  const PersonaModel({
    this.id = '',
    this.estado = '',
    this.dataOriginal = '',
    this.nombre = '',
    this.telefono = '',
    this.fechaNacimiento = '',
  }) : super(idItem: id, descripcionItem: nombre);

  ///Se pasa a json unicamente las propiedades editables
  @override
  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "telefono": telefono,
        "fechaNacimiento": fechaNacimiento,
      };

  ///[data] Son todos las propiedades propias de cada clase se reciben a travez de un mapa
  ///para tener un copyWith generico y no dependa de ningun modelo en particular
  @override
  PersonaModel copyWith({
    String? id,
    String? estado,
    String? dataOriginal,
    Map<String, dynamic>? data,
  }) =>

      ///Se busca en el mapa que contenga las claves propias del modelo si no se pasa el valor que ya poseia
      PersonaModel(
        id: id ?? this.id,
        estado: estado ?? this.estado,
        dataOriginal: dataOriginal ?? this.dataOriginal,
        nombre: data?["nombre"] ?? nombre,
        telefono: data?["telefono"] ?? telefono,
        fechaNacimiento: data?["fechaNacimiento"] ?? fechaNacimiento,
      );

  ///Devuelve unicamente un mapa con los datos que se haya modificado del modelo. Es utilizado en
  ///[CloudCdmBaseEvent] para verificar si existen modificaciones antes de actualizar
  @override
  Map<String, dynamic> dataModificada() {
    final dataModificada = Utilidades.newMap(

        ///DataOriginal unicamente posee los valores que son editables
        mapaOriginal: copyWith(data: json.decode(dataOriginal)).toJson(),
        mapaActualizado: toJson());
    return dataModificada;
  }

  @override
  List<Object?> get props => [
        id,
        estado,
        dataOriginal,
        nombre,
        telefono,
        fechaNacimiento,
      ];

  ///Este mapa se utiliza en los formularios de las vistas para mostrar los nombres de los campos definidos en los values
  ///los [key] son los mismos que el modelo de la clase
  static Map<String, String> titulosFormulario = {
    'nombre': 'Apellido y Nombre',
    'telefono': 'Numero de telefono',
    'fechaNacimiento': 'Fecha de Nacimiento',
  };
}
