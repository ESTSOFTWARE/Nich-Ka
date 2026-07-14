import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../components/app_tab.dart';
import 'go_home.dart';

void onBottomNavSelected(BuildContext context, AppTab tab) {
  switch (tab) {
    case AppTab.inicio:
      goHome(context);
    case AppTab.lotes:
      context.go('/fermentations');
    case AppTab.asistente:
      context.push('/chat');
    case AppTab.sensores:
      context.push('/sensors');
  }
}
