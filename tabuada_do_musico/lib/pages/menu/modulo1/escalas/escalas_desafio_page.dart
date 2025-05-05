// Arquivo: escala_desafio_page.dart

import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import '../../../../models/escalas.dart';

class EscalasDesafioPage extends StatefulWidget {
  const EscalasDesafioPage({super.key});

  @override
  State<EscalasDesafioPage> createState() => _EscalasDesafioPageState();
}

class _EscalasDesafioPageState extends State<EscalasDesafioPage> {
  late List<Map<String, dynamic>> exerciciosDisponiveis = [];
  bool mostrarTelaExercicio = false;
  String tipoSelecionado = '';
  Map<String, dynamic> escalaAtual = {};
  List<String> selecaoUsuario = [];
  int acertos = 0;
  int tentativas = 0;
  int numQuestoes = 8;
  int tempoMaximo = 32;
  Timer? timer;
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
    _carregarEstatisticas();
  }

  Future<void> _carregarEstatisticas() async {
    final String resposta =
        await rootBundle.loadString('assets/data/estatisticas.json');
    final Map<String, dynamic> data = json.decode(resposta);

    final bool mostrarTutorial =
        data['estatisticas']['escalas']['mostrar_tutorial'];

    final Map<String, dynamic> escalasStatsCru =
        data['estatisticas']['escalas'];

    final List<Map<String, dynamic>> escalasStats = [];

    escalasStatsCru.forEach((key, value) {
      if (value is Map<String, dynamic> && value.containsKey('bloqueado')) {
        escalasStats.add({
          'nome': key,
          'bloqueado': value['bloqueado'],
          'medalha': value['medalha'],
          'tempo_atual': value['tempo_atual'],
          'melhor_tempo': value['melhor_tempo'],
          'pontuacao_atual': value['pontuacao_atual'],
          'melhor_pontuacao': value['melhor_pontuacao'],
        });
      }
    });

    setState(() {
      exerciciosDisponiveis = escalasStats;
    });

    if (mostrarTutorial) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _mostrarDialogoTutorial();
      });
    }
  }

  Future<void> _mostrarDialogoTutorial() async {
    final String tutorialTxt = await rootBundle
        .loadString('assets/data/tutoriais/escalas/esc_tutorial_desafio.txt');

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
            onPressed: () => Navigator.of(context).pop(),
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

  List<Map<String, dynamic>> gerarEscalasFiltradas(String filtro) {
    List<List<String>> estruturasPermitidas = [];

    if (filtro.contains("Maior")) estruturasPermitidas.add(Escala.escalaMaior);
    if (filtro.contains("Harmônica"))
      estruturasPermitidas.add(Escala.escalaMenorHarmonica);
    if (filtro.contains("Melódica"))
      estruturasPermitidas.add(Escala.escalaMenorMelodica);
    if (estruturasPermitidas.isEmpty) {
      estruturasPermitidas = [
        Escala.escalaMaior,
        Escala.escalaMenorHarmonica,
        Escala.escalaMenorMelodica
      ];
    }

    List<String> tonalidades = notasPossiveis;
    List<Map<String, dynamic>> escalas = [];
    Random random = Random();

    for (int i = 0; i < 10; i++) {
      String tonica = tonalidades[random.nextInt(tonalidades.length)];
      List<String> estrutura =
          estruturasPermitidas[random.nextInt(estruturasPermitidas.length)];
      Escala escala = Escala(tonica: tonica, estrutura: estrutura);
      escalas.add({
        'nome': '${escala.nomeEscala} de $tonica',
        'notas': escala.gerarNotas().values.toList(),
      });
    }

    return escalas;
  }

  void iniciarNovoExercicio() {
    selecaoUsuario.clear();
    List<Map<String, dynamic>> escalas = gerarEscalasFiltradas(tipoSelecionado);
    escalaAtual = escalas.first;
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
    List<dynamic> notasCorretas = escalaAtual['notas'];
    bool correto = const SetEquality().equals(
      selecaoUsuario.toSet(),
      notasCorretas.toSet(),
    );

    setState(() {
      tentativas++;
      if (correto) {
        acertos++;
      } else {
        if (escalasErradas == '')
          escalasErradas += '${escalaAtual['nome']}';
        else
          escalasErradas += ', ${escalaAtual['nome']}';
      }

      if (tentativas < numQuestoes)
        iniciarNovoExercicio();
      else
        tempoMaximo = 0;
    });
  }

  void mostrarResultado() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Resultado'),
        content:
            Text('Pontuação: $acertos/$tentativas\nErros: $escalasErradas'),
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
    if (!mostrarTelaExercicio) {
      return Scaffold(
        appBar: AppBar(title: Text('Desafio: Formação de Escalas')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selecione um grupo de escalas',
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Notas da escala: ${escalaAtual['nome']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Tempo restante: $tempoMaximo segundos'),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: notasPossiveis.map((nota) {
                final selecionada = selecaoUsuario.contains(nota);
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      if (selecionada) {
                        selecaoUsuario.remove(nota);
                      } else {
                        selecaoUsuario.add(nota);
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selecionada ? Colors.green : Colors.blueAccent,
                  ),
                  child: Text(nota),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: verificarResposta,
              child: Text('Verificar Resposta'),
            )
          ],
        ),
      ),
    );
  }
}
