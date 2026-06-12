import 'package:flutter/material.dart';

/// Responsabilidad única: gestionar el ciclo de vida de un [ChangeNotifier]
/// (crearlo, exponerlo a la UI y liberarlo) para que las vistas puedan ser
/// `StatelessWidget`.
///
/// La UI dentro de [builder] se reconstruye automáticamente cuando el
/// provider llama a `notifyListeners()`.
class ChangeNotifierProvider<T extends ChangeNotifier> extends StatefulWidget {
  final T Function() create;
  final Widget Function(BuildContext context, T provider) builder;

  const ChangeNotifierProvider({
    super.key,
    required this.create,
    required this.builder,
  });

  @override
  State<ChangeNotifierProvider<T>> createState() =>
      _ChangeNotifierProviderState<T>();
}

class _ChangeNotifierProviderState<T extends ChangeNotifier>
    extends State<ChangeNotifierProvider<T>> {
  late final T _provider;

  @override
  void initState() {
    super.initState();
    _provider = widget.create();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _provider,
      builder: (context, _) => widget.builder(context, _provider),
    );
  }
}
