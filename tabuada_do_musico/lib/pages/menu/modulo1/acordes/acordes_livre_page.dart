import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcc_app/database/tonalidades/bemois.dart';
import 'package:tcc_app/database/tonalidades/naturais.dart';
import 'package:tcc_app/database/tonalidades/sustenidos.dart';
import 'dart:async';
import 'dart:math';
import '../../../../models/acordes.dart';

class AcordesLivrePage extends StatefulWidget {
  const AcordesLivrePage({super.key});

  @override
  _AcordesLivrePageState createState() => _AcordesLivrePageState();
}

class _AcordesLivrePageState extends State<AcordesLivrePage> {
  bool _tutorialFinalizado = false;
  int contadorAcordesSorteados = 0;
  late Map<String, dynamic> acordeAtual;
  List<String> selecaoUsuario = [];
  int acertos = 0;
  int tentativas = 0;
  Timer? timer;
  int tempoRestante = 30;
  String acordesErrados = '';
  List<String> notasPossiveis = [
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mostrarDialogoTutorial();
    });
  }

  Future<void> _mostrarDialogoTutorial() async {
    final String tutorialTxt = await rootBundle
        .loadString('assets/data/tutoriais/acordes/ac_tutorial_livre.txt');

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
                  Navigator.of(context).pop(),
                  iniciarNovoExercicio(),
                  setState(() {
                    _tutorialFinalizado = true;
                  })
                },
                child: Text('Entendido'),
              ),
            ],
          );
        });
  }

  // Função para gerar acordes aleatórios
  List<Map<String, dynamic>> gerarAcordesAleatorios() {
    Random random = Random();
    List<Map<String, dynamic>> acordes = [];

    List<String> tonalidadesPossiveis = notasNaturais.keys.toList();

    List<String> tiposDeAcordes = Acorde.formulas.keys.toList();

    for (int i = 0; i < 10; i++) {
      if (i > 3) {
        tonalidadesPossiveis +=
            notasBemois.keys.toList() + notasSustenidas.keys.toList();
      }

      String fundamental =
          tonalidadesPossiveis[random.nextInt(tonalidadesPossiveis.length)];
      String tipo = tiposDeAcordes[random.nextInt(tiposDeAcordes.length)];

      Acorde acorde = Acorde(fundamental, tipo);

      acordes.add({
        'nome': acorde.toString(),
        'notas': acorde.mapearNotas(fundamental),
      });
    }

    return acordes;
  }

  void iniciarNovoExercicio() {
    setState(() {
      selecaoUsuario.clear();
      // Sorteia novos acordes
      List<Map<String, dynamic>> acordesSorteados = gerarAcordesAleatorios();
      acordeAtual =
          acordesSorteados.first; // Pega o primeiro acorde para o exercício
      iniciarTimer();
    });
  }

  void iniciarTimer() {
    timer?.cancel();
    tempoRestante = 30;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (tempoRestante > 0) {
        setState(() {
          tempoRestante--;
        });
      } else {
        timer.cancel();
        mostrarResultado();
      }
    });
  }

  void verificarResposta() {
    List<dynamic> notasCorretas = acordeAtual['notas'].map((notaMap) {
      return notaMap.values.first;
    }).toList();

    bool respostaCorreta = const SetEquality()
        .equals(selecaoUsuario.toSet(), notasCorretas.toSet());
    tentativas++;
    if (respostaCorreta) {
      acertos++;
      alertaSubmeterResposta('Correto!');
      iniciarNovoExercicio();
    } else {
      if (acordesErrados.isEmpty) {
        acordesErrados = acordeAtual['nome'];
      } else {
        if (!acordesErrados.contains(acordeAtual['nome'])) {
          acordesErrados += ', ' + acordeAtual['nome'];
        }
      }
      alertaSubmeterResposta('Errou!');
    }
  }

  void alertaSubmeterResposta(String mensagem) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          Future.delayed(Duration(milliseconds: 500), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 4),
            content: SizedBox(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(mensagem + ' '),
              if (mensagem.contains('Errou'))
                const Icon(Icons.close, color: Colors.red)
              else
                const Icon(Icons.check_circle, color: Colors.green)
            ])),
          );
        });
  }

  void mostrarResultado() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Fim do tempo!'),
        content: SingleChildScrollView(
          child: Text(
              'Pontuação: $acertos/$tentativas tentativas.\nEstude os acordes: $acordesErrados'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              iniciarNovoExercicio();
              acertos = 0;
              tentativas = 0;
              tempoRestante = 30;
            },
            child: Text('Tentar novamente'),
          ),
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
    return Scaffold(
      appBar: AppBar(title: Text('Formação de Acordes')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double larguraDisponivel = constraints.maxWidth;

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
                    Text('Tempo: ${tempoRestante}s '),
                    Text('| Respostas: $tentativas'),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  // height: alturaDisponivel * 0.7,
                  width: larguraDisponivel * 0.8,
                  child: GridView.count(
                    crossAxisCount: 5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                    shrinkWrap: true,
                    physics:
                        NeverScrollableScrollPhysics(), // So it doesn't scroll separately
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
                          shape: const CircleBorder(),
                          padding: EdgeInsets.all(20),
                          backgroundColor: selecaoUsuario.contains(nota)
                              ? Colors.green
                              : const Color.fromARGB(255, 100, 185, 255),
                        ),
                        child: FittedBox(
                          fit: BoxFit.fill,
                          child: Text(
                            nota,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                if (selecaoUsuario.isNotEmpty) ...[
                  SizedBox(height: 20),
                  Text(
                    'Notas Selecionadas:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: selecaoUsuario.map((nota) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          nota,
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: verificarResposta,
                  child: Text('Verificar resposta'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
