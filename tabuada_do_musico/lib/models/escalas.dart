import 'package:collection/collection.dart';
import 'package:tcc_app/database/tonalidades/bemois.dart';
import 'package:tcc_app/database/tonalidades/sustenidos.dart';
import 'package:tcc_app/database/tonalidades/naturais.dart';

class Escala {
  final String tonica;
  final List<String> estrutura;

  Escala({
    required this.tonica,
    required this.estrutura,
  });

  // 🎼 Estruturas de escala (intervalos)
  static const List<String> escalaMaior = [
    '1J',
    '2M',
    '3M',
    '4J',
    '5J',
    '6M',
    '7M'
  ];

  static const List<String> escalaMenorMelodica = [
    '1J',
    '2M',
    '3m',
    '4J',
    '5J',
    '6M',
    '7M'
  ];

  static const List<String> escalaMenorHarmonica = [
    '1J',
    '2M',
    '3m',
    '4J',
    '5J',
    '6m',
    '7M'
  ];

  /// Obtem o mapa de notas com base na tônica
  Map<String, String> get mapaTonal {
    if (tonica.contains('b')) {
      return notasBemois[tonica] ??
          (throw Exception('Tonalidade bemol não encontrada: $tonica'));
    } else if (tonica.contains('#')) {
      return notasSustenidas[tonica] ??
          (throw Exception('Tonalidade sustenida não encontrada: $tonica'));
    } else {
      return notasNaturais[tonica] ??
          (throw Exception('Tonalidade natural não encontrada: $tonica'));
    }
  }

  /// Gera o mapa de intervalos para notas da escala
  Map<String, String> gerarNotas() {
    final mapa = mapaTonal;

    return {
      for (final intervalo in estrutura)
        intervalo: mapa[intervalo] ??
            (throw Exception(
                'Intervalo $intervalo não encontrado na tonalidade de $tonica'))
    };
  }

  String get nomeEscala {
    const eq = ListEquality();
    if (eq.equals(estrutura, escalaMaior)) {
      return 'Maior';
    } else if (eq.equals(estrutura, escalaMenorHarmonica)) {
      return 'Menor Harmônica';
    } else if (eq.equals(estrutura, escalaMenorMelodica)) {
      return 'Menor Melódica';
    }
    return 'Escala Desconhecida';
  }
}
