import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String tipoSelecionado = '';
  Map<String, dynamic> acordeAtual = {};
  List<String> selecaoUsuario = [];
  int acertos = 0;
  int tentativas = 0;
  int numQuestoes = 8;
  int tempoMaximo = 32;
  Timer? timer;
  String acordesErrados = '';

  bool _tutorialFinalizado = false;

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
  }

  Future<void> _carregarEstatisticas() async {
    final String resposta =
        await rootBundle.loadString('assets/data/estatisticas.json');
    final Map<String, dynamic> data = json.decode(resposta);

    final bool mostrarTutorial =
        data['estatisticas']['acordes']['mostrar_tutorial'];

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

    if (mostrarTutorial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mostrarDialogoTutorial();
      });
    }
  }

  Future<void> _mostrarDialogoTutorial() async {
    final String tutorialTxt = await rootBundle
        .loadString('assets/data/tutoriais/acordes/ac_tutorial_desafio.txt');

    showDialog(
      context: context,
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

  void _selecionaExercicio(String tipo) {
    setState(() {
      tipoSelecionado = tipo;
      mostrarTelaExercicio = true;
      iniciarNovoExercicio();
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
    Random random = Random();

    for (int i = 0; i < 10; i++) {
      if (i == 4) {
        tonalidades +=
            notasSustenidas.keys.toList() + notasBemois.keys.toList();
      }

      String tonica = tonalidades[random.nextInt(tonalidades.length)];
      String tipo = tiposPermitidos[random.nextInt(tiposPermitidos.length)];

      Acorde acorde = Acorde(tonica, tipo);
      acordes.add({
        'nome': acorde.toString(),
        'notas': acorde.mapearNotas(tonica),
      });
    }

    return acordes;
  }

  void iniciarNovoExercicio() {
    selecaoUsuario.clear();
    List<Map<String, dynamic>> acordes = gerarAcordesFiltrados(tipoSelecionado);
    acordeAtual = acordes.first;
    iniciarTimer();
  }

  void iniciarTimer() {
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (tempoMaximo > 0) {
        setState(() {
          tempoMaximo--;
        });
      } else {
        timer.cancel();
        mostrarResultado();
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
        iniciarNovoExercicio();
      else {
        tempoMaximo = 0;
      }
    });
  }

  void mostrarResultado() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Resultado'),
        content: SingleChildScrollView(
            child: Text(
                'Pontuação: $acertos/$tentativas\nErros: $acordesErrados')),
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
            )
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Desafio: $tipoSelecionado')),
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
                Text('Tempo restante: $tempoMaximo segundos'),
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
                        onPressed: () {
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
                  onPressed: verificarResposta,
                  child: Text('Verificar Resposta'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
