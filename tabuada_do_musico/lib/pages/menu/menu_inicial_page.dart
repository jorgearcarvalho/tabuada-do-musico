import 'package:flutter/material.dart';

class MenuInicialPage extends StatelessWidget {
  const MenuInicialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tabuada do Músico'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(50, 50),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/menuPrincipal');
              },
              child: const Text('Módulo I', style: TextStyle(fontSize: 20)),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size(50, 50)),
              onPressed: () {
                Navigator.pushNamed(context, '/creditos');
              },
              child: const Text('Creditos', style: TextStyle(fontSize: 20)),
            )
          ],
        ),
      ),
    );
  }
}
