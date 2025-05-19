import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:tcc_app/pages/creditos_page.dart';
import 'package:tcc_app/pages/menu/menu_pages.dart';
import 'pages/home_page.dart';
import 'pages/menu/modulo1/intervalos/menu_intervalos_page.dart';
import 'package:tcc_app/pages/menu/modulo1/acordes/menu_acordes_page.dart';
import 'package:tcc_app/pages/menu/modulo1/escalas/menu_escalas_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Chama a função de cópia do arquivo de forma assíncrona com tratamento de erros
  await copyJsonToEditableDirectory().catchError((e) {
    print("Erro ao copiar o arquivo JSON: $e");
  });

  runApp(const MyApp());
}

Future<void> copyJsonToEditableDirectory() async {
  try {
    // Obtém o diretório onde o arquivo será copiado
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File(
        '$path/TDM_estatisticas.json'); // Defina o nome do seu arquivo JSON aqui

    // Verifica se o arquivo já existe no diretório editável
    if (!await file.exists()) {
      // Carrega o arquivo JSON do bundle de recursos
      final data = await rootBundle.load(
          'assets/data/estatisticas.json'); // Ajuste o caminho se necessário
      final bytes = data.buffer.asUint8List();

      // Copia os bytes para o diretório editável
      await file.writeAsBytes(bytes);
    }
  } catch (e) {
    print("Erro ao copiar o arquivo JSON: $e");
    rethrow;
  }
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
        '/escalas': (context) => MenuEscalasPage(),
        '/creditos': (context) => const CreditosPage()
      },
    );
  }
}
