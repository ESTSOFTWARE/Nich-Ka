import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/app_drawer_item.dart';

void onDrawerNav(BuildContext context, AppDrawerItem item) {
  Navigator.pop(context);
  switch (item) {
    case AppDrawerItem.inicio:
      context.go('/home');
    case AppDrawerItem.fermentaciones:
      context.push('/fermentations');
    case AppDrawerItem.asistente:
      context.go('/asistente');
    case AppDrawerItem.sensores:
    case AppDrawerItem.reportes:
    case AppDrawerItem.historico:
      break;
  }
}
