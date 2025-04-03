/*

    Página de teste para exercício de Campo Harmônico, 
    para identificar a função de cada acorde.

*/

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tcc_app/database/tonalidades.dart';
import 'package:tcc_app/models/acordes.dart';

class CampoHarmonicoPage2 extends StatefulWidget {
  @override
  _CampoHarmonicoPage2State createState() => _CampoHarmonicoPage2State();
}

class _CampoHarmonicoPage2State extends State<CampoHarmonicoPage2> {
  // Campos harmônicos apenas com tétrades
  static const Map<String, List<Map<String, String>>> campos = {
    'maior': [
      {'grau': 'IM7', 'formula': '7M'},
      {'grau': 'iim7', 'formula': 'min7'},
      {'grau': 'iiim7', 'formula': 'min7'},
      {'grau': 'IVM7', 'formula': '7M'},
      {'grau': 'V7', 'formula': '7'},
      {'grau': 'vim7', 'formula': 'min7'},
      {'grau': 'viiø', 'formula': 'm7b5'},
    ],
    'menor': [
      {'grau': 'im7', 'formula': 'min7'},
      {'grau': 'iiø', 'formula': 'm7b5'},
      {'grau': 'IIIM7', 'formula': '7M'},
      {'grau': 'ivm7', 'formula': 'min7'},
      {'grau': 'V7', 'formula': '7'},
      {'grau': 'VIM7', 'formula': '7M'},
      {'grau': 'VII7', 'formula': '7'},
    ],
  };

  String? tonalidadeAtual;
  String modo = 'maior';
  List<Map<String, dynamic>> campoHarmonico = [];
  int acordeAtualIndex = 0;
  bool respostaMostrada = false;

  @override
  void initState() {
    super.initState();
    _gerarNovoExercicio();
  }

  void _gerarNovoExercicio() {
    final notas = tonalidades.keys.toList();
    final random = Random();

    setState(() {
      tonalidadeAtual = notas[random.nextInt(notas.length)];
      modo = random.nextBool() ? 'maior' : 'menor';
      campoHarmonico = _construirCampoTetrades(tonalidadeAtual!, modo);
      acordeAtualIndex = 0;
      respostaMostrada = false;
    });
  }

  List<Map<String, dynamic>> _construirCampoTetrades(
      String fundamental, String modo) {
    return campos[modo]!.map((grauInfo) {
      final acorde = Acorde(fundamental, grauInfo['formula']!);
      final notas = acorde.mapearNotas(fundamental);
      return {
        'grau': grauInfo['grau'],
        'acorde': acorde.toString(),
        'notas': notas,
      };
    }).toList();
  }

  void _verificarResposta(String grauSelecionado) {
    final grauCorreto = campoHarmonico[acordeAtualIndex]['grau'];
    final acerto = grauSelecionado == grauCorreto;

    setState(() {
      respostaMostrada = true;
    });
    Future.delayed(Duration(seconds: 2), () {
      if (acordeAtualIndex < campoHarmonico.length - 1) {
        setState(() {
          acordeAtualIndex++;
          respostaMostrada = false;
        });
      } else {
        _gerarNovoExercicio();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (tonalidadeAtual == null) return CircularProgressIndicator();

    final acordeAtual = campoHarmonico[acordeAtualIndex];
    final grausDisponiveis =
        campos[modo]!.map((e) => e['grau'] as String).toList();

    return Scaffold(
      appBar: AppBar(
          title: Text('Identifique as Tétrades - $tonalidadeAtual $modo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Acorde ${acordeAtualIndex + 1}/${campoHarmonico.length}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(acordeAtual['acorde'],
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    Text(
                      acordeAtual['notas'].map((n) => n['note']).join(' - '),
                      style: TextStyle(fontSize: 20, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            if (!respostaMostrada) ...[
              Text('Qual a função harmônica?', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: grausDisponiveis.map((grau) {
                  return ElevatedButton(
                    onPressed: () => _verificarResposta(grau),
                    child: Text(grau),
                  );
                }).toList(),
              ),
            ] else ...[
              Icon(
                respostaMostrada ? Icons.check : Icons.close,
                color: respostaMostrada ? Colors.green : Colors.red,
                size: 50,
              ),
              SizedBox(height: 20),
              Text(
                respostaMostrada
                    ? 'Correto! ${acordeAtual['grau']}'
                    : 'Errado! Era ${acordeAtual['grau']}',
                style: TextStyle(
                  fontSize: 20,
                  color: respostaMostrada ? Colors.green : Colors.red,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
