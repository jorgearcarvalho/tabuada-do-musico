import 'package:flutter/material.dart';
import 'package:tcc_app/pages/menu/modulo1/acordes/acordes_livre_page.dart';
import 'acordes_desafio_page.dart';

class MenuAcordesPage extends StatelessWidget {
  const MenuAcordesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estudando Acordes')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Modo Livre', style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AcordesLivrePage()));
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              child: const Text('Modo Desafio', style: TextStyle(fontSize: 20)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AcordesDesafioPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
