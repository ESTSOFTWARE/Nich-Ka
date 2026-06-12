import 'package:flutter/material.dart';

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
