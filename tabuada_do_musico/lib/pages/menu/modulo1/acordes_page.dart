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

    if (contadorAcordesSorteados >= 5 && contadorAcordesSorteados < 10) { tonalidadesPossiveis = notasBemois.keys.toList();}
    else if (contadorAcordesSorteados >= 10) { tonalidadesPossiveis = notasSustenidas.keys.toList();}

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

    print(acordes);

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

  bool compararNotas(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    
    for (int i =0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    
    return true;
  }

  void verificarResposta() {
    print(selecaoUsuario);
    print(acordeAtual);
    bool respostaCorreta = compararNotas(selecaoUsuario.toSet().toList(), acordeAtual.values.toList().cast<String>()); // Debugar
    tentativas++;
    if (respostaCorreta) {
      acertos++;
      print('novo exercicio');
      iniciarNovoExercicio();
    }
  }

  void mostrarResultado() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Fim do tempo!'),
        content: Text('Você acertou $acertos de $tentativas tentativas.'),
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
                  children: notasNaturais.keys.map((nota) {
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
                SizedBox(height: 15),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: notasBemois.keys.map((nota) {
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
                SizedBox(height: 15),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: notasSustenidas.keys.map((nota) {
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
