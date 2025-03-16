import 'package:flutter/material.dart';
import 'package:tcc_app/pages/progressoes_page.dart';
import 'package:tcc_app/pages/tetrades_page.dart';
import './pages/home_page.dart';
import './pages/intervalos_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Harmonia Funcional - App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/intervalos': (context) => IntervalosPage(),
          '/tetrades': (context) => TetradesPage(),
          '/harmonia': (context) => ExercicioHarmonia(),
        });
  }
}
