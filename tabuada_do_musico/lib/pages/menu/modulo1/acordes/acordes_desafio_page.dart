import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AcordesDesafioPage extends StatefulWidget {
  const AcordesDesafioPage({super.key});

  @override
  _AcordesDesafioPageState createState() => _AcordesDesafioPageState();
}

class _AcordesDesafioPageState extends State<AcordesDesafioPage> {
  late List<Map<String, dynamic>> exerciciosDisponiveis = [];

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
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Tutorial'),
            content: Text(tutorialTxt,
                textAlign: TextAlign.justify, style: TextStyle(fontSize: 16)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Entendido'),
              ),
            ],
          );
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

  void _selecionaExercicio(String acordeTipo) {
    setState(() {
      print(acordeTipo);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Desafio: Intervalos'),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Selecione um grupo de acorde',
                  style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Column(
                children: exerciciosDisponiveis.map((acordeMapeado) {
                  final nome = acordeMapeado['nome'];
                  final bloqueado = acordeMapeado['bloqueado'];
                  final medalha = acordeMapeado['medalha'];

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
                              : () => _selecionaExercicio(nome),
                          child: Text(nome),
                        )
                      ],
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ));
  }
}
