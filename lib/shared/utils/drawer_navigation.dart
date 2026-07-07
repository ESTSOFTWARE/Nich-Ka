import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/app_drawer_item.dart';

void onDrawerNav(BuildContext context, AppDrawerItem item) {
  switch (item) {
    case AppDrawerItem.inicio:
      context.go('/home');
    case AppDrawerItem.fermentaciones:
      context.push('/fermentations');
    case AppDrawerItem.asistente:
      context.push('/chat');
    case AppDrawerItem.mensajes:
      context.push('/messages');
    case AppDrawerItem.calculadora:
      context.push('/calculator');
    case AppDrawerItem.reportes:
      context.push('/reports');
    case AppDrawerItem.simulador:
      context.push('/simulator');
    case AppDrawerItem.sensores:
      context.push('/sensors');
    case AppDrawerItem.clases:
      context.push('/classes');
  }
}
