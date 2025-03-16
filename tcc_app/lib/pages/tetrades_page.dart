import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class TetradesPage extends StatefulWidget {
  @override
  _TetradesPageState createState() => _TetradesPageState();
}

class _TetradesPageState extends State<TetradesPage> {
  final List<Map<String, dynamic>> acordes = [
    {
      'nome': 'Cmaj7',
      'notas': ['C', 'E', 'G', 'B']
    },
    {
      'nome': 'Dm7',
      'notas': ['D', 'F', 'A', 'C']
    },
    {
      'nome': 'G7',
      'notas': ['G', 'B', 'D', 'F']
    },
    {
      'nome': 'Am7',
      'notas': ['A', 'C', 'E', 'G']
    },
  ];

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

  void iniciarNovoExercicio() {
    setState(() {
      acordeAtual = (acordes..shuffle()).first;
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
    tentativas++;
    if (ListEquality()
        .equals(selecaoUsuario.toSet().toList(), acordeAtual['notas'])) {
      acertos++;
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
      appBar: AppBar(title: Text('Exercício de Tétrades')),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Identifique as notas do acorde: ${acordeAtual['nome']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 15),
          Wrap(
            spacing: 10,
            children: ['C', 'D', 'E', 'F', 'G', 'A', 'B']
                .map((nota) => ElevatedButton(
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
                              : const Color.fromARGB(255, 100, 185, 255)),
                    ))
                .toList(),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: verificarResposta,
            child: Text('Verificar Resposta'),
          ),
          SizedBox(height: 20),
          Text('Tempo restante: $tempoRestante segundos'),
        ],
      )),
    );
  }
}
