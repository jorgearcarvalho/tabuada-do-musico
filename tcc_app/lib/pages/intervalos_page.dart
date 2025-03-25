import '../database/dc_intervalos.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class IntervalosPage extends StatefulWidget {
  @override
  _IntervalosPageState createState() => _IntervalosPageState();
}

class _IntervalosPageState extends State<IntervalosPage> {
  String notaAtual = '';
  List<String> notasSorteadas = [];
  String intervaloAtual = '';
  String respostaCorreta = '';
  String notaEscolhida = '';
  String respostaFinalDoUsuario = '';
  String intervaloSelecionado = '';
  String acidenteEscolhido = ''; // Novo estado para o acidente escolhido
  final List<String> notasPossiveis = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
  final List<String> acidentesPossiveis = ['bb', 'b', '#', 'x'];
  final List<String> intervalosDisponiveis = [
    '2m',
    '2M',
    '3m',
    '3M',
    '4J',
    '5d',
    '5J',
    '6m',
    '6M',
    '7m',
    '7M'
  ];

  // Timer-related variables
  late Timer _timer;
  int _contadorTempo = 0;
  final int _maxTempo = 60; // Set your desired time limit in seconds
  int _contadorRespostas = 0;
  final int _maxRespostas = 18; // Set your desired number of answers

  // State variable to control interval selection visibility
  bool _mostrarSessaoIntervalos = true;

  // To track answers
  List<Map<String, dynamic>> _respostas = [];

  @override
  void initState() {
    super.initState();
  }

  void _startContador() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _contadorTempo++;
        if (_contadorTempo >= _maxTempo ||
            _contadorRespostas >= _maxRespostas) {
          _stopContador();
          _onComplete();
        }
      });
    });
  }

  void _stopContador() {
    if (_timer.isActive) {
      _timer.cancel();
    }
  }

  void _onComplete() {
    int correctAnswers =
        _respostas.where((answer) => answer['isCorrect']).length;
    int incorrectAnswers = _respostas.length - correctAnswers;

    String wrongAnswersDetails = _respostas
        .where((answer) => !answer['isCorrect'])
        .map((answer) =>
            "${answer['interval']} de ${answer['nota']} - Correto: ${answer['correta']} / Sua resposta: ${answer['usuario']}")
        .join('\n');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fim do exercício'),
          content: Text(
              'Você completou o exercício!\n\nAcertos: $correctAnswers\nErros: $incorrectAnswers\n\nErros Detalhados:\n$wrongAnswersDetails'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _contadorTempo = 0;
                  _contadorRespostas = 0;
                  intervaloSelecionado = '';
                  _respostas.clear();
                  _mostrarSessaoIntervalos = true;
                });
              },
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void _gerarQuestao() {
    // Seleciona uma nota aleatória a partir das chaves do mapa de intervalos
    notaAtual = intervalosMapeados.keys
        .elementAt(Random().nextInt(intervalosMapeados.length));

    // Sorteia até encontrar uma nota nova
    while (notasSorteadas.contains(notaAtual)) {
      notaAtual = intervalosMapeados.keys
          .elementAt(Random().nextInt(intervalosMapeados.length));
    }

    // Obtém os intervalos possíveis para a nota sorteada
    final intervalosPorNota = intervalosMapeados[notaAtual]!;

    // Define o intervalo atual com base no intervalo selecionado pelo usuário
    intervaloAtual = intervaloSelecionado;

    // Define a resposta correta com base no intervalo e nota sorteada
    respostaCorreta = intervalosPorNota[intervaloAtual]!;

    notasSorteadas.add(notaAtual);
    setState(() {});
  }

  void _selecionaNota(String notaMusical) {
    setState(() {
      notaEscolhida = notaMusical;
    });
  }

  void _selecionaAcidente(String acidente) {
    setState(() {
      acidenteEscolhido = acidente;
    });
  }

  void _submitResposta() {
    final respostaDoUsuario = notaEscolhida + acidenteEscolhido;
    final isCorreto = respostaDoUsuario == respostaCorreta;

    _respostas.add({
      'nota': notaAtual,
      'interval': intervaloAtual,
      'correta': respostaCorreta,
      'usuario': respostaDoUsuario,
      'isCorrect': isCorreto
    });

    setState(() {
      _contadorRespostas++;
      if (_contadorRespostas >= _maxRespostas) {
        _stopContador();
        _onComplete();
      } else {
        _gerarQuestao();
        notaEscolhida = ''; // Limpa a nota escolhida
        acidenteEscolhido = ''; // Limpa o acidente escolhido
      }
    });
  }

  void _selecionaIntervalo(String intervalo) {
    setState(() {
      intervaloSelecionado = intervalo;
      _gerarQuestao();
      _startContador();
      _mostrarSessaoIntervalos = false;
    });
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
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
              if (_mostrarSessaoIntervalos) ...[
                const Text(
                  'Selecione um intervalo para praticar',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 20,
                  runSpacing: 10,
                  alignment: WrapAlignment.start,
                  runAlignment: WrapAlignment.start,
                  children: intervalosDisponiveis.map((intervalo) {
                    return ElevatedButton(
                      onPressed: () => _selecionaIntervalo(intervalo),
                      child: Text(intervalo),
                    );
                  }).toList(),
                ),
              ] else ...[
                const SizedBox(height: 20),
                Text('Tempo: $_contadorTempo / $_maxTempo s'),
                const SizedBox(height: 10),
                Text('Respostas: $_contadorRespostas / $_maxRespostas'),
                const SizedBox(height: 20),
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
                    controller: TextEditingController(
                        text: notaEscolhida + acidenteEscolhido),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: notasPossiveis.map((notaMusical) {
                    return ElevatedButton(
                      onPressed: () => _selecionaNota(notaMusical),
                      child: Text(notaMusical),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 10,
                  children: acidentesPossiveis.map((accidental) {
                    return ElevatedButton(
                      onPressed: notaEscolhida.isEmpty
                          ? null
                          : () => _selecionaAcidente(accidental),
                      child: Text(accidental),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (notaEscolhida.isEmpty) ? null : _submitResposta,
                  child: const Text('Submit'),
                ),
                const SizedBox(height: 100),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
