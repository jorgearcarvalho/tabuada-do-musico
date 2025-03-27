import 'package:flutter/material.dart';
import 'package:tcc_app/pages/menu/menu_inicial_page.dart';
import './pages/home_page.dart';
import 'package:tcc_app/pages/menu/menu_principal_page.dart';
import 'pages/menu/exercicios/intervalos_page.dart';
import 'package:tcc_app/pages/menu/exercicios/acordes_page.dart';
import 'package:tcc_app/pages/menu/exercicios/escalas_page.dart';
import 'package:tcc_app/pages/menu/exercicios/harmonia_page.dart';

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
          '/menuInicial': (context) => MenuInicialPage(),
          '/menuPrincipal': (context) => const MenuPrincipalPage(),
          '/intervalos': (context) => IntervalosPage(),
          '/tetrades': (context) => TetradesPage(),
          '/escalas': (context) => EscalasPage(), // implementar
          '/harmonia': (context) => const ExercicioHarmonia(), // implementar
        });
  }
}
