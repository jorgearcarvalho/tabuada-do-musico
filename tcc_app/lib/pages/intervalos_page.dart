import 'package:flutter/material.dart';
import '../database/intervalos_naturais.dart';
import 'dart:math'; // Importa para usar Random na geração de perguntas

class IntervalosPage extends StatefulWidget {
  @override
  _IntervalosPageState createState() => _IntervalosPageState();
}

class _IntervalosPageState extends State<IntervalosPage> {
  String notaAtual = '';
  String intervaloAtual = '';
  String respostaCorreta = '';
  String notaEscolhida = '';
  String intervaloSelecionado = '';
  final List<String> notes = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
  final List<String> accidentals = ['♭', '', '♯'];
  final List<String> intervalosDisponiveis = ['3m', '3M', '4J', '5J'];

  @override
  void initState() {
    super.initState();
    // Gera uma pergunta apenas se um intervalo estiver selecionado
    if (intervaloSelecionado.isNotEmpty) {
      _gerarQuestao();
    }
  }

  void _gerarQuestao() {
    // Escolhe uma nota aleatoriamente
    notaAtual = notes[Random().nextInt(notes.length)];
    final intervalosPorNota = intervalos[notaAtual]!;
    intervaloAtual = intervaloSelecionado; // Usa o intervalo selecionado
    respostaCorreta = intervalosPorNota[intervaloAtual]!;
    notaEscolhida = ''; // Apaga a nota escolhida
    setState(() {});
  }

  void _selecionaNota(String notaMusical) {
    setState(() {
      notaEscolhida = notaMusical; // Atualiza a nota escolhida
    });
  }

  void _checkAnswer(String accidental) {
    final respostaDoUsuario =
        notaEscolhida + accidental; // Adiciona o acidente à nota
    final isCorreto = respostaDoUsuario == respostaCorreta;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isCorreto ? 'Correto!' : 'Incorreto!'),
          content: Text(isCorreto
              ? 'Você acertou!'
              : 'A resposta correta era: $respostaCorreta'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _gerarQuestao();
              },
              child: const Text('Próxima questão'),
            ),
          ],
        );
      },
    );
  }

  void _selecionaIntervalo(String intervalo) {
    setState(() {
      intervaloSelecionado = intervalo; // Atualiza o intervalo selecionado
      _gerarQuestao(); // Gera uma nova pergunta com o intervalo selecionado
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Praticando Intervalos'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Seção para selecionar o intervalo
                const Text(
                  'Selecione um intervalo para praticar',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: intervalosDisponiveis.map((intervalo) {
                    return ElevatedButton(
                      onPressed: () => _selecionaIntervalo(intervalo),
                      child: Text(intervalo),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // Seção para exibir a pergunta se um intervalo estiver selecionado
                if (intervaloSelecionado.isNotEmpty) ...[
                  Text(
                    '$intervaloAtual de $notaAtual',
                    style: const TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 150,
                    child: TextField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        hintText: 'Nota',
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(text: notaEscolhida),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: notes.map((notaMusical) {
                      return ElevatedButton(
                        onPressed: () => _selecionaNota(notaMusical),
                        child: Text(notaMusical),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: accidentals.map((accidental) {
                      return ElevatedButton(
                        onPressed: notaEscolhida.isEmpty
                            ? null // Desabilita os botões de acidentes até que uma nota seja selecionada
                            : () => _checkAnswer(accidental),
                        child: Text(accidental),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 100)
                ],
              ],
            ),
          ),
        ));
  }
}
