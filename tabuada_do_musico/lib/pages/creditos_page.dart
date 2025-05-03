import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreditosPage extends StatelessWidget {
  const CreditosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Creditos'),
        ),
        body: Container(
            padding: EdgeInsets.all(40),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                "Este aplicativo foi desenvolvido como parte do Trabalho de Conclusão de Curso (TCC) do Bacharelado em Ciência da Computação, com o objetivo de proporcionar uma abordagem interativa e gamificada para o estudo de elementos fundamentais do campo que constitui a harmonia. \n\nIdealizado e implementado por \nJorge Augusto Rocha de Carvalho \ne Matheus Silva Araújo. \n\nSob orientação de Daniel da Silva Souza.",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.justify,
              )
            ])));
  }
}
