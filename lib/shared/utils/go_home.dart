import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/navigation/entry_route.dart';

void goHome(BuildContext context) {
  resolveEntryRoute().then((route) {
    if (context.mounted) context.go(route);
  });
}
