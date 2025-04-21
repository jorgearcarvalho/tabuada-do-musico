import 'package:flutter/material.dart';

class EscalasPage extends StatefulWidget {
  @override
  _EscalasPageState createState() => _EscalasPageState();
}

class _EscalasPageState extends State<EscalasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Formação de Escalas')),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Center(child:Text('Em desenvolvimento'))
            ]
        )
      );
  }
}
