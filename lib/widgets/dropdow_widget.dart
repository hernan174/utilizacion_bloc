import 'package:flutter/material.dart';
import 'package:utilizacion_bloc/models/modelo_base.dart';

///Widget de dropdow utilizado para realizar una seleccion de un item
///[T] Widget que trabaja unicamente con instancias de modelos que extiendan de [ModeloBase].
///Si no se utiliza esa clase no podra utilizar el widget
///[ValorDefecto] Se utiliza para predeterminar la seleccion de un elemento que se encuentre dentro de `valores`
///[valores] Listado para cargar el dropdow
///[onChanged] Cada vez que se seleccione un nuevo elemento de la lista se disparara esta funcion
///devolviendo el nuevo elemento seleccionado
class DropdowWidget<T extends ModeloBase> extends StatefulWidget {
  const DropdowWidget(
      {Key? key,
      this.valorDefecto,
      required this.valores,
      required this.maxWidth,
      required this.titulo,
      this.onChanged,
      this.icono})
      : super(key: key);
  final T? valorDefecto;
  final List<T> valores;
  final double maxWidth;
  final String titulo;
  final ValueChanged<T>? onChanged;
  final Icon? icono;
  @override
  State<DropdowWidget> createState() => _DropdowWidgetState();
}

class _DropdowWidgetState<T extends ModeloBase>
    extends State<DropdowWidget<T>> {
  ///Item seleccionado es del tipo [T] representado que es una clase que extienda de [ModeloBase]
  ///Ejemplo [PaisModel] o [PersonaModel]
  T? valorDefecto;

  @override
  void initState() {
    super.initState();

    ///Se hace esta verificacion antes de setear el valor por defecto ya que si [valorDefecto]
    ///[No se encuentra] en la lista de [widget.valores] generara un error
    if (!widget.valores.contains(widget.valorDefecto)) {
      ///Al setear un null el selector se limpia de su seleccion
      valorDefecto = null;
    } else {
      valorDefecto = widget.valorDefecto;
    }
  }

  ///Este evento se dispara cada vez que sea llamado el [setState]
  @override
  void didUpdateWidget(covariant DropdowWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    ///Se hace esta verificacion antes de setear el valor por defecto ya que si [valorDefecto]
    ///[No se encuentra] en la lista de [widget.valores] generara un error
    if (!widget.valores.contains(widget.valorDefecto)) {
      ///Al setear un null el selector se limpia de su seleccion
      valorDefecto = null;
    } else {
      valorDefecto = widget.valorDefecto;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.maxWidth,
      height: 37,
      child: DropdownButtonFormField<T>(
        value: valorDefecto,
        icon: widget.icono ?? const Icon(Icons.arrow_drop_down_sharp),
        elevation: 10,
        isExpanded: true,
        borderRadius: BorderRadius.circular(5),
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
            labelText: widget.titulo,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(3),
                borderSide: BorderSide(
                    width: 10, color: Theme.of(context).primaryColor)),
            labelStyle: Theme.of(context)
                .textTheme
                .headline4!
                .copyWith(color: Colors.black54, fontSize: 13),
            contentPadding: const EdgeInsets.only(
              right: 5,
              left: 10,
              bottom: 25,
            )),
        onChanged: (T? newValue) {
          ///Este evento se dispara cada vez que se seleccione un item
          setState(() {
            valorDefecto = newValue;

            ///Dispara la accion de onChange del widget para informar a su padre que cambio la seleccion
            widget.onChanged?.call(newValue!);
          });
        },

        ///Se pasa el modelo de la clase a una lista de [DropdownMenuItem]
        items: widget.valores.map<DropdownMenuItem<T>>((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: SizedBox(
              width: widget.maxWidth * 0.77,
              child: Text(
                value.descripcionItem,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
