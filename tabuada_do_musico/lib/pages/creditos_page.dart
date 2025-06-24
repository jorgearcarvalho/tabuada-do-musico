import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreditosPage extends StatelessWidget {
  const CreditosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Créditos'),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Este aplicativo foi desenvolvido como parte do Trabalho de Conclusão de Curso do Bacharelado em Ciência da Computação.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 16),
              Text(
                "Seu objetivo é oferecer uma abordagem interativa e gamificada para o estudo de elementos fundamentais da harmonia musical.",
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 32),
              Text(
                "Idealizado e implementado por",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Jorge Augusto Rocha de Carvalho\nMatheus Silva Araújo",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),
              Text(
                "Orientador",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Daniel da Silva Souza",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ));
  }
}
