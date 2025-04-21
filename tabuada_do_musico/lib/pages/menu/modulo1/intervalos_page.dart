import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tcc_app/database/tonalidades/bemois.dart';
import 'package:tcc_app/database/tonalidades/sustenidos.dart';
import '../../../database/tonalidades/naturais.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class IntervalosMenuPage extends StatelessWidget {
  const IntervalosMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Treino de Intervalos')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Modo Livre', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => IntervalosPage()));
              },
              child: const Text('Modo Desafio', style: TextStyle(fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }
}

class IntervalosPage extends StatefulWidget {
  @override
  _IntervalosPageState createState() => _IntervalosPageState();
}

class _IntervalosPageState extends State<IntervalosPage> {
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
    _carregarIntervalos(); // Adicionar fluidez no carregamento
  }

  Future<void> _carregarIntervalos() async {
    final String response =
        await rootBundle.loadString('assets/data/estatisticas.json');
    final Map<String, dynamic> data = json.decode(response);

    final Map<String, dynamic> intervalosRaw =
        data['estatisticas']['intervalos'];

    final List<Map<String, dynamic>> intervalos = [];

    intervalosRaw.forEach((key, value) {
      if (value is Map<String, dynamic> && value.containsKey('bloqueado')) {
        intervalos.add({
          'nome': key,
          'bloqueado': value['bloqueado'],
          'medalha': value['medalha'],
          "tempo_atual": value['tempo_atual'],
          "melhor_tempo": value['melhor_tempo'],
          "pontuacao_atual": value['pontuacao_atual'],
          "melhor_pontuacao": value['melhor_pontuacao'],
        });
      }
    });

    setState(() {
      intervalosDisponiveis = intervalos;
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
      acidenteEscolhido = ''; // Limpa o acidente
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

  void _selecionaIntervalo(String intervalo) {
    setState(() {
      intervaloSelecionado = intervalo;
      _gerarQuestao();
      _startContador();
      _mostrarSessaoIntervalos = false;
    });
  }

  Color _retornaMedalhaCor(int medalha) {
    switch (medalha) {
      case 3:
        return Colors.amber;
      case 2:
        return Colors.grey;
      case 1:
        return Colors.brown;
      default:
        return Colors.grey.withOpacity(0.3);
    }
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
                Column(
                  children: [
                    ...intervalosDisponiveis.map((intervaloMap) {
                      final nome = intervaloMap['nome'];
                      final bloqueado = intervaloMap['bloqueado'] as bool;
                      final medalha = intervaloMap['medalha'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 7.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (!bloqueado)
                              Icon(Icons.emoji_events,
                                  color: _retornaMedalhaCor(medalha), size: 24),
                            const SizedBox(width: 5),
                            ElevatedButton(
                              onPressed: bloqueado
                                  ? null
                                  : () => _selecionaIntervalo(nome),
                              child: Text(nome),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                        child: Column(
                      children: [
                        Container(
                            height: 8,
                            width: 150,
                            child: LinearProgressIndicator(
                              value: _contadorRespostas / _maxRespostas,
                              minHeight: 8,
                              backgroundColor: Colors.grey[300],
                              color: Colors.blue,
                            )),
                        SizedBox(height: 5),
                        Text(
                          'Progresso',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    )),
                  ],
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
