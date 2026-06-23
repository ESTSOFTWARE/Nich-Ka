import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as pkg;

class ChangeNotifierProvider<T extends ChangeNotifier> extends StatelessWidget {
  final T Function() create;
  final Widget Function(BuildContext context, T provider) builder;

  const ChangeNotifierProvider({
    super.key,
    required this.create,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return pkg.ChangeNotifierProvider<T>(
      create: (_) => create(),
      child: pkg.Consumer<T>(
        builder: (context, provider, _) => builder(context, provider),
      ),
    );
  }
}
