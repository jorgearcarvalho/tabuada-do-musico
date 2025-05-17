import 'dart:async';
import 'dart:math';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcc_app/database/tonalidades/bemois.dart';
import 'package:tcc_app/database/tonalidades/naturais.dart';
import 'package:tcc_app/database/tonalidades/sustenidos.dart';
import 'package:tcc_app/models/escalas.dart';

class EscalasLivrePage extends StatefulWidget {
  const EscalasLivrePage({super.key});

  @override
  _EscalasLivrePageState createState() => _EscalasLivrePageState();
}

class _EscalasLivrePageState extends State<EscalasLivrePage> {
  bool _tutorialFinalizado = false;
  late Map<String, dynamic> escalaAtual;
  List<String> selecaoUsuario = [];
  int acertos = 0;
  int tentativas = 0;
  Timer? timer;
  int tempoRestante = 30;
  String escalasErradas = '';

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
        .loadString('assets/data/tutoriais/escalas/esc_tutorial_livre.txt');

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
      },
    );
  }

  // Gera escalas aleatórias
  List<Map<String, dynamic>> gerarEscalasAleatorias() {
    Random random = Random();
    List<Map<String, dynamic>> escalas = [];

    List<String> tonalidades = notasNaturais.keys.toList() +
        notasBemois.keys.toList() +
        notasSustenidas.keys.toList();
    List<List<String>> estruturas = [
      Escala.escalaMaior,
      Escala.escalaMenorHarmonica,
      Escala.escalaMenorMelodica,
    ];

    for (int i = 0; i < 10; i++) {
      String tonica = tonalidades[random.nextInt(tonalidades.length)];
      List<String> estrutura = estruturas[random.nextInt(estruturas.length)];

      Escala escala = Escala(tonica: tonica, estrutura: estrutura);
      escalas.add({
        'nome': '${escala.tonica} ${escala.nomeEscala}',
        'notas': escala.gerarNotas().values.toList(),
      });
    }

    return escalas;
  }

  void iniciarNovoExercicio() {
    setState(() {
      selecaoUsuario.clear();
      List<Map<String, dynamic>> escalasSorteadas = gerarEscalasAleatorias();
      escalaAtual = escalasSorteadas
          .first; // Seleciona a primeira escala para o exercício
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
    List<dynamic> notasCorretas = escalaAtual['notas'];
    bool respostaCorreta = const SetEquality()
        .equals(selecaoUsuario.toSet(), notasCorretas.toSet());

    tentativas++;
    if (respostaCorreta) {
      acertos++;
      iniciarNovoExercicio();
    } else {
      escalasErradas += escalaAtual['nome'] + ' | ';
    }
  }

  void mostrarResultado() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Fim do tempo!'),
        content: SingleChildScrollView(
          child: Text(
              'Pontuação: $acertos/$tentativas tentativas.\nErros: $escalasErradas'),
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
        appBar: AppBar(title: Text('Exercício de Escalas')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text('Exercício de Escalas')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double larguraDisponivel = constraints.maxWidth;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Identifique as notas da escala: \n${escalaAtual['nome']}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text('Tempo restante: $tempoRestante segundos'),
                SizedBox(height: 10),
                Container(
                  width: larguraDisponivel * 0.8,
                  child: GridView.count(
                    crossAxisCount: 5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: notasPossiveis.map((nota) {
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (selecaoUsuario.contains(nota)) {
                              selecaoUsuario.remove(nota);
                            } else if (selecaoUsuario.length < 7) {
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
                          fit: BoxFit.fill,
                          child: Text(
                            nota,
                            style: TextStyle(
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
                  child: Text('Submeter'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
