import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/app_tab.dart';

void onBottomNavSelected(BuildContext context, AppTab tab) {
  switch (tab) {
    case AppTab.inicio:
      context.go('/home');
    case AppTab.lotes:
      context.go('/fermentations');
    case AppTab.asistente:
      context.push('/chat');
    case AppTab.sensores:
      break;
  }
}
