import 'package:flutter/material.dart';
import 'package:tcc_app/pages/creditos_page.dart';
import 'package:tcc_app/pages/menu/menu_pages.dart';
import 'pages/home_page.dart';
import 'pages/menu/modulo1/intervalos/menu_intervalos_page.dart';
import 'package:tcc_app/pages/menu/modulo1/acordes/menu_acordes_page.dart';
import 'package:tcc_app/pages/menu/modulo1/escalas/menu_escalas_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tabuada do Músico',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/menu': (context) => MenuPages(),
          '/intervalos': (context) => MenuIntervalosPage(),
          '/acordes': (context) => MenuAcordesPage(),
          '/escalas': (context) => MenuEscalasPage(), // implementar
          '/creditos': (context) => const CreditosPage()
        });
  }
}
