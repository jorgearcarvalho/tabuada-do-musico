import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tcc_app/database/tonalidades/bemois.dart';
import 'package:tcc_app/database/tonalidades/naturais.dart';
import 'package:tcc_app/database/tonalidades/sustenidos.dart';
import '../../../../models/acordes.dart';

class AcordesDesafioPage extends StatefulWidget {
  const AcordesDesafioPage({super.key});

  @override
  _AcordesDesafioPageState createState() => _AcordesDesafioPageState();
}

class _AcordesDesafioPageState extends State<AcordesDesafioPage> {
  late List<Map<String, dynamic>> exerciciosDisponiveis = [];
  bool mostrarTelaExercicio = false;
  String exercicioAcordeTipoSelecionado = '';
  Map<String, dynamic> acordeAtual = {};
  List<String> selecaoUsuario = [];
  int acertos = 0;
  int tentativas = 0;
  int numQuestoes = 10;
  int tempoMaximo = 50;
  int _contadorTempo = 0;
  Timer? timer;
  String acordesErrados = '';

  List<Map<String, dynamic>>? acordesGerados = null;

  double _pontuacaoFinal = 0;

  bool _tutorialFinalizado = false;
  bool _exercicioFinalizado = false;

  final List<String> notasPossiveis = [
    'Cbb',
    'Cb',
    'C',
    'C#',
    'Cx',
    'Dbb',
    'Db',
    'D',
    'D#',
    'Dx',
    'Ebb',
    'Eb',
    'E',
    'E#',
    'Ex',
    'Fbb',
    'Fb',
    'F',
    'F#',
    'Fx',
    'Gbb',
    'Gb',
    'G',
    'G#',
    'Gx',
    'Abb',
    'Ab',
    'A',
    'A#',
    'Ax',
    'Bbb',
    'Bb',
    'B',
    'B#',
    'Bx'
  ];

  @override
  void initState() {
    super.initState();
    _carregarEstatisticas();
    _mostrarDialogoTutorial();
  }

  Future<void> _mostrarDialogoTutorial() async {
    final String tutorialTxt = await rootBundle
        .loadString('assets/data/tutoriais/acordes/ac_tutorial_desafio.txt');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('Tutorial'),
        content: Text(
          tutorialTxt,
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => {
              setState(() => _tutorialFinalizado = true),
              Navigator.of(context).pop()
            },
            child: Text('Entendido'),
          ),
        ],
      ),
    );
  }

  Future<void> _carregarEstatisticas() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/TDM_estatisticas.json');

    final String resposta = await file.readAsString();
    final Map<String, dynamic> data = json.decode(resposta);

    // final bool mostrarTutorial =
    //     data['estatisticas']['acordes']['mostrar_tutorial'];

    final Map<String, dynamic> acordesStatsCru =
        data['estatisticas']['acordes'];

    final List<Map<String, dynamic>> acordesStats = [];

    acordesStatsCru.forEach((key, value) {
      if (value is Map<String, dynamic> && value.containsKey('bloqueado')) {
        acordesStats.add({
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
      exerciciosDisponiveis = acordesStats;
    });
  }

  Future<void> _atualizarEstatisticasNoJSON() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/TDM_estatisticas.json');

    if (!await file.exists()) return;

    final String content = await file.readAsString();
    final Map<String, dynamic> data = json.decode(content);

    final Map<String, dynamic> acordesData = data['estatisticas']['acordes'];

    _pontuacaoFinal = (acertos / numQuestoes) * 100;
    int medalhaObtida = _entregarMedalha(_pontuacaoFinal);

    final Map<String, dynamic> dadosExercicioAtual =
        acordesData[exercicioAcordeTipoSelecionado];

    // Atualizando dados no JSON editavel
    // Atualiza melhor pontuação/tempo se for o caso
    if (_pontuacaoFinal > dadosExercicioAtual['melhor_pontuacao']) {
      dadosExercicioAtual['melhor_pontuacao'] = _pontuacaoFinal.toInt();
    }

    if (_contadorTempo < dadosExercicioAtual['melhor_tempo'] ||
        dadosExercicioAtual['melhor_tempo'] == 0) {
      dadosExercicioAtual['melhor_tempo'] = _contadorTempo;
    }

    // Atualiza medalha se for melhor
    if (medalhaObtida > dadosExercicioAtual['medalha']) {
      dadosExercicioAtual['medalha'] = medalhaObtida;
    }

    // Desbloqueia o proximo exercicio, se houver
    List<String> chaves = acordesData.keys
        .where((key) =>
            key != 'mostrar_tutorial' &&
            key != 'notas_possiveis' &&
            key != 'acidentes_possiveis')
        .toList();

    int atualIndex = chaves.indexOf(exercicioAcordeTipoSelecionado);
    if (atualIndex != -1 &&
        atualIndex < chaves.length - 1 &&
        medalhaObtida >= 2) {
      final proximoIntervalo = chaves[atualIndex + 1];
      if (acordesData[proximoIntervalo] != null) {
        acordesData[proximoIntervalo]['bloqueado'] = false;
      }
    }

    // Escreve de volta o JSON atualizado
    await file.writeAsString(JsonEncoder.withIndent('  ').convert(data));
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

  int _entregarMedalha(double _pontuacaoFinal) {
    if (_pontuacaoFinal >= 50 && _pontuacaoFinal < 70) return 1;

    if (_pontuacaoFinal >= 70 && _pontuacaoFinal < 90) return 2;

    if (_pontuacaoFinal >= 90) return 3;

    return 0;
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

  void _selecionaExercicio(String tipo) {
    setState(() {
      exercicioAcordeTipoSelecionado = tipo;
      mostrarTelaExercicio = true;
      iniciarExercicio();
    });
  }

  List<Map<String, dynamic>> gerarAcordesFiltrados(String filtro) {
    List<String> tiposPermitidos = [];

    switch (filtro) {
      case 'Maior e menor':
        tiposPermitidos = ['', 'm'];
        break;
      case 'Aumentado e Suspenso':
        tiposPermitidos = ['5+', 'sus4'];
        break;
      case 'Maior com 7M e 7':
        tiposPermitidos = ['7M', '7'];
        break;
      case 'menor com 7M e 7':
        tiposPermitidos = ['m7', 'm7M'];
        break;
      case 'Diminuto e meio-diminuto':
        tiposPermitidos = ['°', 'm7b5'];
        break;
      default:
        tiposPermitidos = Acorde.formulas.keys.toList();
    }

    List<String> tonalidades = notasNaturais.keys.toList();
    List<Map<String, dynamic>> acordes = [];
    Set<String> mapaDeAcordesSorteadosAEvitar = {};
    Random random = Random();

    for (int i = 0; i < 10; i++) {
      if (i == 4) {
        tonalidades +=
            notasSustenidas.keys.toList() + notasBemois.keys.toList();
      }

      String tonica = tonalidades[random.nextInt(tonalidades.length)];
      String tipo = tiposPermitidos[random.nextInt(tiposPermitidos.length)];

      // Evitando sortear acordes duplicados
      String chave = '$tonica$tipo';
      if (mapaDeAcordesSorteadosAEvitar.contains("$tonica$tipo")) {
        i--;
        continue;
      }
      mapaDeAcordesSorteadosAEvitar.add(chave);

      Acorde acorde = Acorde(tonica, tipo);
      acordes.add({
        'nome': acorde.toString(),
        'notas': acorde.mapearNotas(tonica),
      });
    }

    return acordes;
  }

  void iniciarExercicio() {
    selecaoUsuario.clear();
    acordesGerados = gerarAcordesFiltrados(exercicioAcordeTipoSelecionado);
    acordeAtual = acordesGerados!.removeAt(0);
    iniciarTimer();
  }

  void iniciarProximoExercicio() {
    selecaoUsuario.clear();
    acordeAtual = acordesGerados!.removeAt(0);
    iniciarTimer();
  }

  void iniciarTimer() {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (tempoMaximo > 0) {
        setState(() {
          _contadorTempo++;
          tempoMaximo--;
        });
      } else {
        timer.cancel();
        _finalizarExercicio();
      }
    });
  }

  void verificarResposta() {
    List<dynamic> notasCorretas =
        acordeAtual['notas'].map((n) => n.values.first).toList();

    bool correto = const SetEquality().equals(
      selecaoUsuario.toSet(),
      notasCorretas.toSet(),
    );

    setState(() {
      tentativas++;
      if (correto) {
        acertos++;
      } else {
        if (acordesErrados == '')
          acordesErrados += '${acordeAtual['nome']}';
        else
          acordesErrados += ', ${acordeAtual['nome']}';
      }

      if (tentativas < numQuestoes)
        iniciarProximoExercicio();
      else {
        tempoMaximo = 0;
      }
    });
  }

  Future<void> _finalizarExercicio() async {
    await _atualizarEstatisticasNoJSON();
    await _carregarEstatisticas();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text('Resultado'),
        content: SingleChildScrollView(
            child: Text(
                'Pontuação: $acertos/$tentativas (${_pontuacaoFinal.toInt()}%)\nErros: $acordesErrados')),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _exercicioFinalizado = true;
                  selecaoUsuario.clear();
                });
              },
              child: const Text('Ok'))
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
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

    if (!mostrarTelaExercicio) {
      return Scaffold(
        appBar: AppBar(title: Text('Desafio: Formação de Acordes')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selecione um grupo de acorde',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Column(
              children: exerciciosDisponiveis.map((e) {
                final nome = e['nome'];
                final bloqueado = e['bloqueado'];
                final medalha = e['medalha'];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!bloqueado)
                        Icon(Icons.emoji_events,
                            color: _retornaMedalhaCor(medalha), size: 24),
                      SizedBox(width: 5),
                      ElevatedButton(
                        onPressed:
                            bloqueado ? null : () => _selecionaExercicio(nome),
                        child: Text(nome),
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
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
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Desafio: $exercicioAcordeTipoSelecionado')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double largura = constraints.maxWidth;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Notas do acorde: ${acordeAtual['nome']}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Tempo: ${tempoMaximo}s '),
                    Text('| Respostas: $tentativas/$numQuestoes'),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  width: largura * 0.8,
                  child: GridView.count(
                    crossAxisCount: 5,
                    shrinkWrap: true,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                    physics: NeverScrollableScrollPhysics(),
                    children: notasPossiveis.map((nota) {
                      return ElevatedButton(
                        onPressed: _exercicioFinalizado
                            ? null
                            : () {
                                setState(() {
                                  if (selecaoUsuario.contains(nota)) {
                                    selecaoUsuario.remove(nota);
                                  } else if (selecaoUsuario.length < 4) {
                                    selecaoUsuario.add(nota);
                                  }
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(20),
                          backgroundColor: selecaoUsuario.contains(nota)
                              ? Colors.green
                              : Color.fromARGB(255, 100, 185, 255),
                        ),
                        child: FittedBox(
                          child: Text(
                            nota,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                if (selecaoUsuario.isNotEmpty) ...[
                  SizedBox(height: 20),
                  Text('Notas Selecionadas:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: selecaoUsuario.map((nota) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child:
                            Text(nota, style: TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                  ),
                ],
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _exercicioFinalizado ? null : verificarResposta,
                  child: Text(
                      tentativas == numQuestoes ? 'Finalizar' : 'Submeter'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
