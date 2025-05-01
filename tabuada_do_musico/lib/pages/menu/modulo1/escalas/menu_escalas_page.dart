import 'package:flutter/material.dart';

class MenuEscalasPage extends StatelessWidget {
  const MenuEscalasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Estudando Escalas')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Modo Livre', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => EscalasPage()));
              },
              child: const Text('Modo Desafio', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}

class EscalasPage extends StatefulWidget {
  @override
  _EscalasPageState createState() => _EscalasPageState();
}

class _EscalasPageState extends State<EscalasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Praticando Escalas')),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Center(child:Text('Em desenvolvimento'))
            ]
        )
      );
  }
}
