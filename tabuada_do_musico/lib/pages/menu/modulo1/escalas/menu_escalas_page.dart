import 'package:flutter/material.dart';
import 'package:tcc_app/pages/menu/modulo1/escalas/escalas_desafio_page.dart';
import 'package:tcc_app/pages/menu/modulo1/escalas/escalas_livre_page.dart';
import 'package:tcc_app/pages/menu/modulo1/escalas/escalas_teoria_page.dart';
import 'package:tcc_app/widgets/imagem_bonequinho.dart';

class MenuEscalasPage extends StatelessWidget {
  const MenuEscalasPage({super.key});

  Future<void> _preloadAssets(BuildContext context) async {
    await precacheImage(
      const AssetImage('assets/images/cientista_escalas.png'),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _preloadAssets(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Estudando Escalas')),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Vamos formular escalas?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const BonequinhoTematico(
                  imagePath: 'assets/images/cientista_escalas.png',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TeoriaEscalasPage()),
                    );
                  },
                  child: const Text('Teoria', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EscalasLivrePage()),
                    );
                  },
                  child:
                      const Text('Modo Livre', style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => EscalasDesafioPage()),
                    );
                  },
                  child: const Text('Modo Desafio',
                      style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
