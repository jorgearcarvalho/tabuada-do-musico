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
        barrierDismissible: false,
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

    final Set<String> errosUnicos = {};
    final List<String> detalhesErros = [];

    for (var answer in _respostas.where((a) => !a['isCorrect'])) {
      String chaveErro = "${answer['nota']}_${answer['interval']}";

      if (!errosUnicos.contains(chaveErro)) {
        errosUnicos.add(chaveErro);
        detalhesErros.add(
            "${answer['interval']} de ${answer['nota']} -> ${answer['correta']}");
      }
    }

    String wrongAnswersDetails = detalhesErros.join('\n');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fim do exercício'),
          content: SingleChildScrollView(
            child: Text(
                'Você completou o exercício!\n\nAcertos: $correctAnswers\nErros: $incorrectAnswers\n\Corrigindo...\n$wrongAnswersDetails'),
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

  void alertaSubmeterResposta(String mensagem) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.of(context).pop(true);
        });
        return AlertDialog(
          insetPadding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 4),
          content: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(mensagem + ' '),
                if (mensagem.contains('Errou'))
                  const Icon(Icons.close, color: Colors.red)
                else
                  const Icon(Icons.check_circle, color: Colors.green)
              ],
            ),
          ),
        );
      },
    );
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

    // Mostra o alerta com base na resposta
    alertaSubmeterResposta(isCorreto ? 'Acertou!' : 'Errou!');

    setState(() {
      _contadorRespostas++;

      if (isCorreto) {
        // Reseta o contador, zerando o tempo
        _stopContador();
        _contadorTempo = 0;
        _startContador();

        // Prepara para receber a próxima resposta
        notaEscolhida = '';
        acidenteEscolhido = '';
        _gerarQuestao();
      }
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
        appBar: AppBar(title: Text('Praticando Intervalos')),
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
              Text(
                '$intervaloAtual de $notaAtual',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Tempo: ${_contadorTempo} / ${_maxTempo}s '),
                  Text('| Respostas: $_contadorRespostas'),
                ],
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
