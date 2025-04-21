import 'package:flutter/material.dart';

class CreditosPage extends StatelessWidget {
  const CreditosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Creditos'),
        ),
        body: const Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Este aplicativo foi desenvolvido \ncomo parte do Trabalho de \nConclusão de Curso (TCC) do \nBacharelado em Ciência da \nComputação, com o objetivo de \nproporcionar uma abordagem \ninterativa e gamificada para o \nestudo de elementos fundamentais \ndo campo que constitui a harmonia.",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 50),
          Text(
            "Alunos: \nJorge Augusto Rocha de Carvalho \nMatheus Silva Araújo",
            style: TextStyle(fontSize: 18),
          )
        ])));
  }
}
