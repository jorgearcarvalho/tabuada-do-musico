import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:tcc_app/database/tonalidades/bemois.dart';
import 'package:tcc_app/database/tonalidades/naturais.dart';
import 'package:tcc_app/database/tonalidades/sustenidos.dart';
import '../../../../models/escalas.dart';

class EscalasDesafioPage extends StatefulWidget {
  const EscalasDesafioPage({super.key});

  @override
  State<EscalasDesafioPage> createState() => _EscalasDesafioPageState();
}

class _EscalasDesafioPageState extends State<EscalasDesafioPage> {
  late List<Map<String, dynamic>> exerciciosDisponiveis = [];
  bool mostrarTelaExercicio = false;
  String exercicioEscalaTipoAtualSelecionado = '';
  Map<String, dynamic> escalaAtual = {};
  List<String> selecaoUsuario = [];
  int acertos = 0;
  int tentativas = 0;
  int numQuestoes = 3;
  int tempoMaximo = 60;
  int _contadorTempo = 0;
  Timer? timer;
  String escalasErradas = '';

  List<Map<String, dynamic>>? escalasGeradas = null;

  double _pontuacaoFinal = 0;

  bool _tutorialFinalizado = false;
  bool _exercicioFinalizado = false;

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
    _mostrarDialogoTutorial();
  }

  Future<void> _mostrarDialogoTutorial() async {
    final String tutorialTxt = await rootBundle
        .loadString('assets/data/tutoriais/escalas/esc_tutorial_desafio.txt');

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
              setState(() {
                _tutorialFinalizado = true;
              }),
              Navigator.of(context).pop(),
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
    // data['estatisticas']['escalas']['mostrar_tutorial'];

    final Map<String, dynamic> escalasStatsCru =
        data['estatisticas']['escalas'];

    final List<Map<String, dynamic>> escalasStats = [];

    escalasStatsCru.forEach((key, value) {
      if (value is Map<String, dynamic> && value.containsKey('bloqueado')) {
        escalasStats.add({
          'nome': key,
          'bloqueado': value['bloqueado'],
          'medalha': value['medalha'],
          'melhor_tempo': value['melhor_tempo'],
          'melhor_pontuacao': value['melhor_pontuacao'],
        });
      }
    });

    setState(() {
      exerciciosDisponiveis = escalasStats;
    });
  }

  Future<void> _atualizarEstatisticasNoJSON() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/TDM_estatisticas.json');

    if (!await file.exists()) return;

    final String content = await file.readAsString();
    final Map<String, dynamic> data = json.decode(content);

    final Map<String, dynamic> estatisticasDoExercicioEscalas =
        data['estatisticas']['escalas'];

    _pontuacaoFinal = (acertos / numQuestoes) * 100;
    int medalhaObtida = _entregarMedalha(_pontuacaoFinal);

    final Map<String, dynamic> dadosExercicioAtual =
        estatisticasDoExercicioEscalas[exercicioEscalaTipoAtualSelecionado];

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
    List<String> chaves = estatisticasDoExercicioEscalas.keys
        .where((key) =>
            key != 'mostrar_tutorial' &&
            key != 'notas_possiveis' &&
            key != 'acidentes_possiveis')
        .toList();

    int atualIndex = chaves.indexOf(exercicioEscalaTipoAtualSelecionado);
    if (atualIndex != -1 &&
        atualIndex < chaves.length - 1 &&
        medalhaObtida >= 2) {
      final proximoIntervalo = chaves[atualIndex + 1];
      if (estatisticasDoExercicioEscalas[proximoIntervalo] != null) {
        estatisticasDoExercicioEscalas[proximoIntervalo]['bloqueado'] = false;
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

  double _calcularProgressoGeral() {
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
      exercicioEscalaTipoAtualSelecionado = tipo;
      mostrarTelaExercicio = true;
      iniciarExercicio();
    });
  }

  List<Map<String, dynamic>> gerarEscalasFiltradas(String filtro) {
    List<List<String>> estruturasPermitidas = [];

    switch (filtro) {
      case 'Maior':
        estruturasPermitidas.add(Escala.escalaMaior);
        break;
      case 'Harmônica':
        estruturasPermitidas.add(Escala.escalaMenorHarmonica);
        break;
      case 'Melódica':
        estruturasPermitidas.add(Escala.escalaMenorMelodica);
        break;
      default:
        estruturasPermitidas = [
          Escala.escalaMaior,
          Escala.escalaMenorHarmonica,
          Escala.escalaMenorMelodica
        ];
    }

    List<String> tonalidades = notasNaturais.keys.toList() +
        notasBemois.keys.toList() +
        notasSustenidas.keys.toList();
    List<Map<String, dynamic>> escalas = [];
    Set<String> mapaDeEscalasSorteadasAEvitar = {};
    Random random = Random();

    for (int i = 0; i < 3; i++) {
      String tonica = tonalidades[random.nextInt(tonalidades.length)];
      List<String> estrutura =
          estruturasPermitidas[random.nextInt(estruturasPermitidas.length)];

      // Evitando sortear escalas duplicadas
      String chave = '$tonica $estrutura';
      if (mapaDeEscalasSorteadasAEvitar.contains("$tonica $estrutura")) {
        i--;
        continue;
      }
      mapaDeEscalasSorteadasAEvitar.add(chave);

      Escala escala = Escala(tonica: tonica, estrutura: estrutura);
      escalas.add({
        'nome': '$tonica ${escala.nomeEscala}',
        'notas': escala.gerarNotas().values.toList(),
      });
    }

    return escalas;
  }

  void iniciarExercicio() {
    selecaoUsuario.clear();
    escalasGeradas = gerarEscalasFiltradas(exercicioEscalaTipoAtualSelecionado);
    escalaAtual = escalasGeradas!.removeAt(0);
    iniciarTimer();
  }

  void iniciarProximoExercicio() {
    selecaoUsuario.clear();
    escalaAtual = escalasGeradas!.removeAt(0);
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
        iniciarProximoExercicio();
      else
        tempoMaximo = 0;
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
                'Pontuação: $acertos/$tentativas (${_pontuacaoFinal.toInt()}%)\nErros: $escalasErradas')),
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
        appBar: AppBar(title: Text('Formação de Escalas')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
            ),
            SizedBox(height: 20),
            Container(
                child: Column(
              children: [
                Container(
                    height: 8,
                    width: 150,
                    child: LinearProgressIndicator(
                      value: _calcularProgressoGeral(),
                      minHeight: 8,
                      backgroundColor: Colors.grey[300],
                      color: Colors.blue,
                    )),
                SizedBox(height: 5),
                Text(
                  'Progresso: ${(_calcularProgressoGeral() * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            )),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Desafio: Escalas')),
      body: LayoutBuilder(builder: (context, constraints) {
        double largura = constraints.maxWidth;
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Notas presentes em ${escalaAtual['nome']}',
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
                      final selecionada = selecaoUsuario.contains(nota);
                      return ElevatedButton(
                        onPressed: _exercicioFinalizado
                            ? null
                            : () {
                                setState(() {
                                  if (selecionada) {
                                    selecaoUsuario.remove(nota);
                                  } else {
                                    selecaoUsuario.add(nota);
                                  }
                                });
                              },
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(20),
                          backgroundColor: selecionada
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
                  )),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _exercicioFinalizado ? null : verificarResposta,
                child:
                    Text(tentativas == numQuestoes ? 'Finalizar' : 'Submeter'),
              )
            ],
          ),
        );
      }),
    );
  }
}
