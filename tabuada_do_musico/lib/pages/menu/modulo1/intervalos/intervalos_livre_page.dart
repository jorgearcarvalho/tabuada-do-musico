import 'package:flutter/services.dart';
import 'package:tcc_app/database/tonalidades/bemois.dart';
import 'package:tcc_app/database/tonalidades/sustenidos.dart';
import '../../../../database/tonalidades/naturais.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class IntervalosLivrePage extends StatefulWidget {
  @override
  _IntervalosLivrePageState createState() => _IntervalosLivrePageState();
}

class _IntervalosLivrePageState extends State<IntervalosLivrePage> {
  int contadorIntervalosSorteados = 0;
  String notaAtual = '';
  List<String> notasSorteadas = [];
  String respostaCorreta = '';
  String notaEscolhida = '';
  String respostaFinalDoUsuario = '';
  String acidenteEscolhido = ''; // Novo estado para o acidente escolhido
  final List<String> notasPossiveis = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
  final List<String> acidentesPossiveis = ['bb', 'b', '#', 'x'];
  String intervaloAtual = '';
  final List<String> intervalosPossiveis = [
    '2m',
    '2M',
    '3m',
    '3M',
    '4J',
    '4A',
    '5d',
    '5J',
    '5A',
    '6m',
    '6M',
    '7d',
    '7m',
    '7M'
  ];

  late Timer _timer;
  int _contadorTempo = 0;
  final int _maxTempo = 10;
  int _contadorRespostas = 0;

  List<Map<String, dynamic>> _respostas = [];
  bool _tutorialFinalizado = false;
  bool exercicioFinalizado = false;

  @override
  void initState() {
    super.initState();
    _mostrarDialogoTutorial();
  }

  Future<void> _mostrarDialogoTutorial() async {
    final String tutorialTxt = await rootBundle
        .loadString('assets/data/tutoriais/intervalos/int_tutorial_livre.txt');

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tutorial'),
            content: Text(tutorialTxt,
                textAlign: TextAlign.justify, style: TextStyle(fontSize: 16)),
            actions: [
              TextButton(
                onPressed: () => {
                  setState(() {
                    _tutorialFinalizado = true;
                  }),
                  Navigator.of(context).pop(),
                  _gerarQuestao(),
                  _startContador()
                },
                child: Text('Entendido'),
              ),
            ],
          );
        });
  }

  void _startContador() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _contadorTempo++;
        if (_contadorTempo >= _maxTempo) {
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
            "${answer['interval']} de ${answer['nota']}. Correto: ${answer['correta']} | Resposta: ${answer['usuario']}")
        .join('\n');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fim do exercício'),
          content: SingleChildScrollView(
            child: Text(
                'Você completou o exercício!\n\nAcertos: $correctAnswers\nErros: $incorrectAnswers\n\nErros Detalhados:\n$wrongAnswersDetails'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _contadorTempo = 0;
                  _contadorRespostas = 0;
                  _respostas.clear();
                  exercicioFinalizado = true;
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
    contadorIntervalosSorteados++;
    Map<String, Map<String, String>> todasAsNotas = {}
      ..addAll(notasNaturais)
      ..addAll(notasBemois)
      ..addAll(notasSustenidas);

    intervaloAtual = intervalosPossiveis
        .elementAt(Random().nextInt(intervalosPossiveis.length));
    notaAtual =
        todasAsNotas.keys.elementAt(Random().nextInt(todasAsNotas.length));

    final intervalosPorNota = todasAsNotas[notaAtual]!;
    respostaCorreta = intervalosPorNota[intervaloAtual]!;
    notasSorteadas.add(notaAtual);

    setState(() {});
  }

  void _selecionaNota(String notaMusical) {
    setState(() {
      acidenteEscolhido = '';
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

      // Reseta o contador, zerando o tempo
      _stopContador();
      _contadorTempo = 0;
      _startContador();

      // Prepara para receber a proxima resposta
      notaEscolhida = '';
      acidenteEscolhido = '';
      _gerarQuestao();
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
    if (!_tutorialFinalizado) {
      return Scaffold(
        appBar: AppBar(title: Text('Formação de Acordes')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
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
              Container(child: Text('Tempo: $_contadorTempo / $_maxTempo s')),
              const SizedBox(height: 10),
              Container(child: Text('Respostas: $_contadorRespostas')),
              const SizedBox(height: 20),
              Container(
                child: Text(
                  '$intervaloAtual de $notaAtual',
                  style: const TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 150,
                child: TextField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: '',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(
                      text: notaEscolhida + acidenteEscolhido),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                child: Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: notasPossiveis.map((notaMusical) {
                    return ElevatedButton(
                      onPressed: (exercicioFinalizado)
                          ? null
                          : () => _selecionaNota(notaMusical),
                      child: Text(notaMusical),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                child: Wrap(
                  spacing: 10,
                  children: acidentesPossiveis.map((accidental) {
                    return ElevatedButton(
                      onPressed: (notaEscolhida.isEmpty || exercicioFinalizado)
                          ? null
                          : () => _selecionaAcidente(accidental),
                      child: Text(accidental),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                child: ElevatedButton(
                  onPressed: (notaEscolhida.isEmpty || exercicioFinalizado)
                      ? null
                      : _submitResposta,
                  child: const Text('Submeter'),
                ),
              ),
              if (exercicioFinalizado)
                Container(
                    padding: EdgeInsets.only(top: 30),
                    child: Text('Exercicio finalizado...'))
            ],
          ),
        ),
      ),
    );
  }
}
