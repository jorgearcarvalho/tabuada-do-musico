import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:tcc_app/database/tonalidades/bemois.dart';
import 'package:tcc_app/database/tonalidades/sustenidos.dart';
import '../../../../database/tonalidades/naturais.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class IntervalosDesafioPage extends StatefulWidget {
  @override
  _IntervalosDesafioPageState createState() => _IntervalosDesafioPageState();
}

class _IntervalosDesafioPageState extends State<IntervalosDesafioPage> {
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
  late List<Map<String, dynamic>> exerciciosDisponiveis = [];

  Timer? _timer;
  int _contadorTempo = 0;
  final int _maxTempo = 60;
  int _contadorRespostas = 0;
  final int _numQuestoes = 18;

  double _pontuacaoFinal = 0;

  bool _mostrarSessaoIntervalos = true;

  List<Map<String, dynamic>> _respostas = [];
  bool _tutorialFinalizado = false;

  @override
  void initState() {
    super.initState();
    _carregarEstatisticas();
    _mostrarDialogoTutorial();
  }

  Future<void> _mostrarDialogoTutorial() async {
    final String tutorialTxt = await rootBundle.loadString(
        'assets/data/tutoriais/intervalos/int_tutorial_desafio.txt');

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
                onPressed: () {
                  setState(() {
                    _tutorialFinalizado = true;
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Entendido'),
              ),
            ],
          );
        });
  }

  Future<void> _carregarEstatisticas() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/TDM_estatisticas.json');

    final String response = await file.readAsString();
    final Map<String, dynamic> data = json.decode(response);

    // final bool mostrarTutorial =
    //     data['estatisticas']['intervalos']['mostrar_tutorial'];

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
      exerciciosDisponiveis = intervalos;
    });
  }

  Future<void> _atualizarEstatisticasNoJSON() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/TDM_estatisticas.json');

    if (!await file.exists()) return;

    final String content = await file.readAsString();
    final Map<String, dynamic> data = json.decode(content);

    final Map<String, dynamic> intervalosData =
        data['estatisticas']['intervalos'];

    // Calcula a pontuação do usuário
    int acertos = _respostas.where((res) => res['isCorrect']).length;
    _pontuacaoFinal = (acertos / _numQuestoes) * 100;
    int medalhaObtida = _entregarMedalha();

    final Map<String, dynamic> intervaloAtualData =
        intervalosData[intervaloSelecionado];

    // Atualiza melhor pontuação/tempo se for o caso
    if (_pontuacaoFinal > intervaloAtualData['melhor_pontuacao']) {
      intervaloAtualData['melhor_pontuacao'] = _pontuacaoFinal.toInt();
    }

    if (_contadorTempo < intervaloAtualData['melhor_tempo'] ||
        intervaloAtualData['melhor_tempo'] == 0) {
      intervaloAtualData['melhor_tempo'] = _contadorTempo;
    }

    // Atualiza medalha se for melhor
    if (medalhaObtida > intervaloAtualData['medalha']) {
      intervaloAtualData['medalha'] = medalhaObtida;
    }

    // Desbloqueia o próximo intervalo se houver
    List<String> chaves = intervalosData.keys
        .where((key) =>
            key != 'mostrar_tutorial' &&
            key != 'notas_possiveis' &&
            key != 'acidentes_possiveis')
        .toList();

    int atualIndex = chaves.indexOf(intervaloSelecionado);
    if (atualIndex != -1 &&
        atualIndex < chaves.length - 1 &&
        medalhaObtida >= 2) {
      final proximoIntervalo = chaves[atualIndex + 1];
      if (intervalosData[proximoIntervalo] != null) {
        intervalosData[proximoIntervalo]['bloqueado'] = false;
      }
    }

    // Escreve de volta o JSON atualizado
    await file.writeAsString(JsonEncoder.withIndent('  ').convert(data));
  }

  double calcularProgressoGeral() {
    if (exerciciosDisponiveis.isEmpty) return 0.0;

    double soma = 0;
    for (var exercicio in exerciciosDisponiveis) {
      int medalha = exercicio['medalha'] ?? 0;
      switch (medalha) {
        case 3:
          soma += 100;
          break;
        case 2:
          soma += 75;
          break;
        case 1:
          soma += 50;
          break;
        default:
          soma += 0;
      }
    }

    return soma / exerciciosDisponiveis.length / 100; // valor entre 0.0 e 1.0
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

  int _entregarMedalha() {
    if (_pontuacaoFinal >= 50 && _pontuacaoFinal < 70) return 1;

    if (_pontuacaoFinal >= 70 && _pontuacaoFinal < 90) return 2;

    if (_pontuacaoFinal >= 90) return 3;

    return 0;
  }

  void _startContador() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _contadorTempo++;
        if (_contadorTempo >= _maxTempo || _contadorRespostas >= _numQuestoes) {
          _stopContador();
          _finalizarExercicio();
        }
      });
    });
  }

  void _stopContador() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
  }

  void _gerarQuestao() {
    // Unir todos os mapas em um só
    Map<String, Map<String, String>> todasNotas = {}
      ..addAll(notasNaturais)
      ..addAll(notasBemois)
      ..addAll(notasSustenidas);

    // Sortear uma nota aleatória
    notaAtual = todasNotas.keys.elementAt(Random().nextInt(todasNotas.length));

    // Evitar repetição
    while (notasSorteadas.contains(notaAtual)) {
      notaAtual =
          todasNotas.keys.elementAt(Random().nextInt(todasNotas.length));
    }

    final intervalosPorNota = todasNotas[notaAtual]!;
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

  void _submeterResposta() {
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
      if (_contadorRespostas >= _numQuestoes) {
        _stopContador();
        _finalizarExercicio();
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

  Future<void> _finalizarExercicio() async {
    int correctAnswers =
        _respostas.where((answer) => answer['isCorrect']).length;
    int incorrectAnswers = _respostas.length - correctAnswers;

    String wrongAnswersDetails = _respostas
        .where((answer) => !answer['isCorrect'])
        .map((answer) =>
            "${answer['interval']} de ${answer['nota']} - Correto: ${answer['correta']} / Sua resposta: ${answer['usuario']}")
        .join('\n');

    await _atualizarEstatisticasNoJSON();
    await _carregarEstatisticas();

    Widget content;

    if (_pontuacaoFinal >= 50) {
      int medalha = _entregarMedalha();
      Color corMedalha = _retornaMedalhaCor(medalha);

      content = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.emoji_events, size: 60, color: corMedalha),
          const SizedBox(height: 16),
          const Text(
            'Parabéns! Você recebeu uma medalha!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Porcentagem de acertos: ${_pontuacaoFinal.toInt()}%\nAcertos: $correctAnswers\nErros: $incorrectAnswers',
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      content = Text(
        'Você completou o exercício!\nPorcentagem de acertos: ${_pontuacaoFinal.toInt()}%\n\nAcertos: $correctAnswers\nErros: $incorrectAnswers\n\nErros Detalhados:\n$wrongAnswersDetails',
        textAlign: TextAlign.left,
      );
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fim do exercício'),
          content: SingleChildScrollView(child: content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _contadorTempo = 0;
                  _contadorRespostas = 0;
                  intervaloSelecionado = '';
                  _respostas.clear();
                  notasSorteadas.clear();
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

  @override
  void dispose() {
    _stopContador();
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
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
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
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: exerciciosDisponiveis.map((intervaloMap) {
                        final nome = intervaloMap['nome'];
                        final bloqueado = intervaloMap['bloqueado'] as bool;
                        final medalha = intervaloMap['medalha'];

                        return SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 50,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (medalha > 0)
                                Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: Icon(
                                    Icons.emoji_events,
                                    color: _retornaMedalhaCor(medalha),
                                    size: 20,
                                  ),
                                ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: bloqueado
                                      ? null
                                      : () => _selecionaIntervalo(nome),
                                  child:
                                      Text(nome, textAlign: TextAlign.center),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
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
                              value: calcularProgressoGeral(),
                              minHeight: 8,
                              backgroundColor: Colors.grey[300],
                              color: Colors.blue,
                            )),
                        SizedBox(height: 5),
                        Text(
                          'Progresso: ${(calcularProgressoGeral() * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    )),
                  ],
                ),
              ] else ...[
                Text(
                  '$intervaloAtual de $notaAtual',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Tempo: ${_contadorTempo} / ${_maxTempo}s '),
                    Text('| Respostas: $_contadorRespostas / $_numQuestoes'),
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
                  onPressed: (notaEscolhida.isEmpty) ? null : _submeterResposta,
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
