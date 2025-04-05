import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:tcc_app/database/tonalidades/bemois.dart';
import 'package:tcc_app/database/tonalidades/naturais.dart';
import 'package:tcc_app/database/tonalidades/sustenidos.dart';
import 'dart:async';
import 'dart:math';
import '../../../models/acordes.dart';

class AcordesPage extends StatefulWidget {
  @override
  _AcordesPageState createState() => _AcordesPageState();
}

class _AcordesPageState extends State<AcordesPage> {
  int contadorAcordesSorteados = 0;
  late Map<String, dynamic> acordeAtual;
  List<String> selecaoUsuario = [];
  int acertos = 0;
  int tentativas = 0;
  Timer? timer;
  int tempoRestante = 30;
  String acordesErrados = '';
  List<String> notasPossiveis = [
    'Cb',
    'Db',
    'Eb',
    'Fb',
    'Gb',
    'Ab',
    'Bb',
    'C',
    'D',
    'E',
    'F',
    'G',
    'A',
    'B',
    'C#',
    'D#',
    'E#',
    'F#',
    'G#',
    'A#',
    'B#',
  ];

  @override
  void initState() {
    super.initState();
    iniciarNovoExercicio();
    iniciarTimer();
  }

  // Função para gerar acordes aleatórios
  List<Map<String, dynamic>> gerarAcordesAleatorios() {
    Random random = Random();
    List<Map<String, dynamic>> acordes = [];

    List<String> tonalidadesPossiveis = notasNaturais.keys.toList();

    if (contadorAcordesSorteados >= 5 && contadorAcordesSorteados < 10) {
      tonalidadesPossiveis = notasBemois.keys.toList();
    } else if (contadorAcordesSorteados >= 10) {
      tonalidadesPossiveis = notasSustenidas.keys.toList();
    }

    List<String> tiposDeAcordes = Acorde.formulas.keys.toList();

    for (int i = 0; i < 10; i++) {
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
      // Sorteia novos acordes
      List<Map<String, dynamic>> acordesSorteados = gerarAcordesAleatorios();
      acordeAtual =
          acordesSorteados.first; // Pega o primeiro acorde para o exercício
      selecaoUsuario.clear();
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

    print(selecaoUsuario);
    print(notasCorretas);

    bool respostaCorreta = const SetEquality()
        .equals(selecaoUsuario.toSet(), notasCorretas.toSet());
    tentativas++;
    if (respostaCorreta) {
      acertos++;
      iniciarNovoExercicio();
    } else if (!respostaCorreta) {
      acordesErrados += acordeAtual['nome'] + '| ';
    }
  }

  void mostrarResultado() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Fim do tempo!'),
        content: Text(
            'Você acertou $acertos de $tentativas tentativas.\nEstude os acordes de: $acordesErrados'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              iniciarNovoExercicio();
              iniciarTimer();
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
    return Scaffold(
      appBar: AppBar(title: Text('Formação de Acordes')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double larguraDisponivel = constraints.maxWidth;
          double alturaDisponivel = constraints.maxHeight;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Identifique as notas do acorde: ${acordeAtual['nome']}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: notasPossiveis.map((nota) {
                    return SizedBox(
                      width: larguraDisponivel * 0.12, // Ajuste proporcional
                      height: alturaDisponivel * 0.07, // Ajuste proporcional
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (selecaoUsuario.contains(nota)) {
                              selecaoUsuario.remove(nota);
                            } else if (selecaoUsuario.length < 4) {
                              selecaoUsuario.add(nota);
                            }
                          });
                        },
                        child: Text(nota),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selecaoUsuario.contains(nota)
                              ? Colors.green
                              : const Color.fromARGB(255, 100, 185, 255),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                // Display selected notes
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
                  child: Text('Verificar Resposta'),
                ),
                SizedBox(height: 20),
                Text('Tempo restante: $tempoRestante segundos'),
              ],
            ),
          );
        },
      ),
    );
  }
}
