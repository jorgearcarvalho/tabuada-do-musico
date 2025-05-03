import 'dart:convert';
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
  String intervaloAtual = '';
  String respostaCorreta = '';
  String notaEscolhida = '';
  String respostaFinalDoUsuario = '';
  String intervaloSelecionado = '';
  String acidenteEscolhido = ''; // Novo estado para o acidente escolhido
  final List<String> notasPossiveis = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
  final List<String> acidentesPossiveis = ['bb', 'b', '#', 'x'];
  late List<Map<String, dynamic>> intervalosDisponiveis = [];

  late Timer _timer;
  int _contadorTempo = 0;
  final int _maxTempo = 60;
  int _contadorRespostas = 0;
  final int _maxRespostas = 18;

  bool _mostrarSessaoIntervalos = true;

  List<Map<String, dynamic>> _respostas = [];

  @override
  void initState() {
    super.initState();
    _mostrarDialogoTutorial();
  }

  Future<void> _mostrarDialogoTutorial() async {
    final String tutorialTxt = await rootBundle
        .loadString('data/tutoriais/intervalos/int_tutorial_livre.txt');

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tutorial'),
            content: Text(tutorialTxt,
                textAlign: TextAlign.justify, style: TextStyle(fontSize: 16)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
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
    contadorIntervalosSorteados++;
    Map<String, Map<String, String>> auxAcidentes = notasNaturais;

    if (contadorIntervalosSorteados >= 6 && contadorIntervalosSorteados < 12) {
      auxAcidentes = notasBemois;
    } else if (contadorIntervalosSorteados >= 12) {
      auxAcidentes = notasSustenidas;
    }

    notaAtual =
        auxAcidentes.keys.elementAt(Random().nextInt(auxAcidentes.length));

    while (notasSorteadas.contains(notaAtual)) {
      notaAtual =
          auxAcidentes.keys.elementAt(Random().nextInt(auxAcidentes.length));
    }

    final intervalosPorNota = auxAcidentes[notaAtual]!;
    intervaloAtual = intervaloSelecionado;
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
      if (_contadorRespostas >= _maxRespostas) {
        _stopContador();
        _onComplete();
      } else {
        notaEscolhida = ''; // Limpa a nota escolhida
        acidenteEscolhido = ''; // Limpa o acidente escolhido
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
          ),
        ),
      ),
    );
  }
}
