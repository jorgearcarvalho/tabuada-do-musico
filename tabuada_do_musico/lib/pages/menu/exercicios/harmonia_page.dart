import 'package:flutter/material.dart';
import 'package:tcc_app/database/tonalidades/naturais.dart';
import 'dart:math';

class CampoHarmonicoPage extends StatefulWidget {
  const CampoHarmonicoPage({super.key});

  @override
  State<CampoHarmonicoPage> createState() => _CampoHarmonicoPageState();
}

class _CampoHarmonicoPageState extends State<CampoHarmonicoPage> {
  late String tonalidadeAtual;
  late String modoAtual; // 'maior' ou 'menor'
  late List<String> acordesCampo;
  late List<String> opcoesModo;
  String mensagem = '';
  bool mostrarResposta = false;

  @override
  void initState() {
    super.initState();
    gerarNovaQuestao();
  }

  void gerarNovaQuestao() {
    final random = Random();

    // Seleciona uma tonalidade aleatória
    tonalidadeAtual =
        notasNaturais.keys.elementAt(random.nextInt(notasNaturais.length));

    // Decide se será maior ou menor
    modoAtual = random.nextBool() ? 'maior' : 'menor';

    // Gera o campo harmônico correspondente
    acordesCampo = gerarCampoHarmonico(tonalidadeAtual, modoAtual);

    // Opções de modo para o usuário escolher
    opcoesModo = ['maior', 'menor'];
    opcoesModo.shuffle();

    mensagem = '';
    mostrarResposta = false;
  }

  List<String> gerarCampoHarmonico(String tonalidade, String modo) {
    final campo = notasNaturais[tonalidade]!;

    if (modo == 'maior') {
      return [
        campo['1J']!, // I
        campo['2m']!, // ii
        campo['3m']!, // iii
        campo['4J']!, // IV
        campo['5J']!, // V
        campo['6m']!, // vi
        campo['7m']!, // vii°
      ];
    } else {
      // menor
      return [
        campo['6m']!, // i
        campo['7m']!, // ii°
        campo['1J']!, // III
        campo['2m']!, // iv
        campo['3m']!, // v
        campo['4J']!, // VI
        campo['5J']!, // VII
      ];
    }
  }

  void verificarResposta(String resposta) {
    setState(() {
      if (resposta == modoAtual) {
        mensagem = 'Correto! 🎵';
      } else {
        mensagem = 'Tente novamente. ❌';
      }
    });
  }

  void revelarResposta() {
    setState(() {
      mostrarResposta = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Identificação de Campos Harmônicos'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Qual é o modo deste campo harmônico?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 30),
              Text('Tonalidade: $tonalidadeAtual',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              Text('Acordes: ${acordesCampo.join(' - ')}',
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 30),
              ...opcoesModo.map((modo) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: SizedBox(
                      width: 200,
                      child: ElevatedButton(
                        onPressed: () => verificarResposta(modo),
                        child: Text(modo.toUpperCase()),
                      ),
                    ),
                  )),
              const SizedBox(height: 20),
              Text(mensagem,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              if (mensagem.isNotEmpty)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      gerarNovaQuestao();
                    });
                  },
                  child: const Text('Próxima Questão'),
                ),
              const SizedBox(height: 20),
              if (!mostrarResposta && mensagem.isNotEmpty)
                TextButton(
                  onPressed: revelarResposta,
                  child: const Text('Revelar Resposta'),
                ),
              if (mostrarResposta)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    'Resposta correta: ${modoAtual.toUpperCase()}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
