import 'package:flutter/material.dart';
import 'package:tcc_app/pages/menu/modulo1/intervalos/intervalos_livre_page.dart';
import 'intervalos_desafio_page.dart';

class MenuIntervalosPage extends StatelessWidget {
  const MenuIntervalosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estudando Intervalos')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => IntervalosLivrePage()));
              },
              child: const Text('Modo Livre', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => IntervalosDesafioPage()));
              },
              child: const Text('Modo Desafio', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}
