import 'package:flutter/material.dart';
import 'package:tcc_app/pages/menu/modulo1/intervalos/intervalos_livre_page.dart';
import 'package:tcc_app/pages/menu/modulo1/intervalos/intervalos_teoria_page.dart';
import 'package:tcc_app/widgets/imagem_bonequinho.dart';
import 'intervalos_desafio_page.dart';

class MenuIntervalosPage extends StatelessWidget {
  const MenuIntervalosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estudando Intervalos')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Vamos mapear intervalos?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const BonequinhoTematico(
                  imagePath: 'assets/images/intervalos_jones.png'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => TeoriaIntervalosPage()));
                },
                child: const Text('Teoria', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => IntervalosLivrePage()));
                },
                child: const Text('Modo Livre', style: TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => IntervalosDesafioPage()));
                },
                child:
                    const Text('Modo Desafio', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
