///Clase [ModeloBaseCdm] es utilizado como base y modelo para las clases que requieran utilizar
///[CloudCdmBaseEvent]`<T extends ModeloBaseCdm, E extends CloudCdmDb>` que es una implementacion
/// para realizar las siguientes acciones basicas con [CDM]= [leeById, leeValidacionById, guardar, actualizar, obtener].
///`T` es una implementacion de esta clase , mientras que `E` es una implementacion
///de [CloudCdmDb]. Ejemplo T=[BotCategoriaModel] y E= [BotCategoriaCdm]
///`id`, `estado`,`dataOriginal` Propiedades comunes para todos los modelos que lo implementen
abstract class ModeloBaseCdm<T> {
  final String id;
  final String estado;
  final String dataOriginal;

  ModeloBaseCdm({this.id = '', this.estado = '', this.dataOriginal = ''});

  ///[dataModificada], [toJson] y [copyWith]
  /// Cada modelo lo implementa a su manera para obtener dichos datos  mientras que en [CloudCdmBaseEvent] Unicamente
  /// se hace el llamado al metodo

  /// `NO` compara las propiedades [id], [estado] y [dataOriginal] ya que son unicamente de lectura.
  /// `SOLO` se compara propiedades que son propias de la clase
  Map<String, dynamic> dataModificada();

  ///Convierte el modelo actual en un map que se utiliza en [CloudCdmBaseEvent] para `guardar`
  ///Igua que [dataModificada]  `SOLO` se compara propiedades que son propias de la clase
  ///// `NO` compara las propiedades [id], [estado] y [dataOriginal] ya que son unicamente de lectura.
  ///[data] Se utiliza para pasar las propiedades que son propias de cada clase para setear los campos de esta clase padre
  ///Utiliza su parametro por nombre
  Map<String, dynamic> toJson();

  ///Realiza una copia del modelo actual cambiando unicamente los datos que se le pasa
  T copyWith(
      {String? id,
      String? estado,
      String? dataOriginal,
      Map<String, dynamic>? data});
}
