import 'package:flutter/material.dart';
import 'dart:math';

class ExercicioHarmonia extends StatefulWidget {
  const ExercicioHarmonia({super.key});

  @override
  State<ExercicioHarmonia> createState() => _ExercicioHarmoniaState();
}

class _ExercicioHarmoniaState extends State<ExercicioHarmonia> {
  final List<Map<String, dynamic>> progresssoes = [
    {
      'acordes': ['C', 'G', 'Am', 'F'],
      'tipo': 'I - V - VI - IV'
    },
    {
      'acordes': ['Dm', 'G', 'C', 'Am'],
      'tipo': 'II - V - I - VI'
    },
    {
      'acordes': ['F', 'G', 'Em', 'Am'],
      'tipo': 'IV - V - III - VI'
    },
  ];

  late Map<String, dynamic> progressaoAtual;
  late List<String> opcoes;
  String mensagem = '';

  @override
  void initState() {
    super.initState();
    gerarNovaQuestao();
  }

  void gerarNovaQuestao() {
    final random = Random();
    progressaoAtual = progresssoes[random.nextInt(progresssoes.length)];
    opcoes = progresssoes.map((p) => p['tipo'] as String).toList();
    opcoes.shuffle();
    mensagem = '';
  }

  void verificarResposta(String resposta) {
    setState(() {
      if (resposta == progressaoAtual['tipo']) {
        mensagem = 'Correto! 🎶';
      } else {
        mensagem = 'Tente novamente. ❌';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progressões Harmônicas'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Identifique a progressão harmônica:',
                style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            Text(progressaoAtual['acordes'].join(' - '),
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ...opcoes.map((opcao) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ElevatedButton(
                    onPressed: () => verificarResposta(opcao),
                    child: Text(opcao),
                  ),
                )),
            const SizedBox(height: 20),
            Text(mensagem,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            if (mensagem == 'Correto! 🎶')
              ElevatedButton(
                onPressed: () {
                  setState(gerarNovaQuestao);
                },
                child: const Text('Próxima questão'),
              ),
          ],
        ),
      ),
    );
  }
}
