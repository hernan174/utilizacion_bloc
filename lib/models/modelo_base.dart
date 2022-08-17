import 'package:equatable/equatable.dart';
import 'package:utilizacion_bloc/widgets/dropdow_widget.dart';

///Esta clase abstracta es utilizada como base para utilizar el widget de [DropdowWidget]
///Las clases que extiendan de el tiene que decir que propiedad utilizaea `idItem` y `descripcionItem`
///[descripcionItem] Sera lo que se vea visualmente en el dropdow para el usuario
///[idItem] Sera lo que se pase para la hora de guardar
abstract class ModeloBase extends Equatable {
  final String idItem;
  final String descripcionItem;

  const ModeloBase({required this.idItem, required this.descripcionItem});
}
