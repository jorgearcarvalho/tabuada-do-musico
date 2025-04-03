import 'package:flutter/material.dart';

class MenuPrincipalPage extends StatelessWidget {
  const MenuPrincipalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabuada do Músico'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(50, 50)),
              onPressed: () {
                Navigator.pushNamed(context, '/intervalos');
              },
              child: const Text('Intervalos', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/acordes');
                },
                child: const Text('Formação de acordes',
                    style: TextStyle(fontSize: 20))),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/harmonia');
                },
                child: const Text('Funções Harmônicas',
                    style: TextStyle(fontSize: 20)))
          ],
        ),
      ),
    );
  }
}
