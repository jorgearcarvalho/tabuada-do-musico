import 'package:tcc_app/database/tonalidades/bemois.dart';
import 'package:tcc_app/database/tonalidades/sustenidos.dart';
import 'package:tcc_app/database/tonalidades/naturais.dart';

class Acorde {
  final String fundamental;
  final String tipo;

  static const Map<String, List<String>> triades = {
    'Maior': ['1J', '3M', '5J'],
    'menor': ['1J', '3m', '5J'],
    'Aum': ['1J', '3M', '6m'], // 6m pra facilitar (implementar 5A)
    'dim': ['1J', '3m', '5d'],
    'sus4': ['1J', '4J', '5J']
  };

  static const Map<String, List<String>> tetrades = {
    '7M': ['1J', '3M', '5J', '7M'], // maior com 7M: 1, 3M, 5J, 7M
    '7': ['1J', '3M', '5J', '7m'], // dominante: 1, 3M, 5J, 7m
    'min7': ['1J', '3m', '5J', '7m'], // menor com 7m: 1, 3m, 5J, 7m
    'm7b5': ['1J', '3m', '5d', '7m'], // meio diminuto: 1, 3m, b5, 7m
    'dim': ['1J', '3m', '5d', '6M'], // diminuto: 1, 3m, b5, 7d (ou 7bb) (6M)
    // Implementar 7d
  };

  static Map<String, List<String>> get formulas => {
        ...triades,
        ...tetrades,
      };

  Acorde(this.fundamental, this.tipo);

  List<Map<String, String>> mapearNotas(String fundamental) {
    final intervalos = formulas[tipo];

    if (intervalos == null) {
      throw Exception('Tipo de acorde desconhecido: $tipo');
    }

    Map<String, String>? mapaDaTonalidade;

    if (fundamental.contains('b')) {
      mapaDaTonalidade = notasBemois[fundamental];
    } else if (fundamental.contains('#')) {
      mapaDaTonalidade = notasSustenidas[fundamental];
    } else {
      mapaDaTonalidade = notasNaturais[fundamental];
    }

    if (mapaDaTonalidade == null) {
      throw Exception('Fundamental inválida ou não encontrada: $fundamental');
    }

    final intervalosMapeados = intervalos.map((intervalo) {
      final nota = mapaDaTonalidade![intervalo];
      if (nota == null) {
        throw Exception('Intervalo desconhecido: $intervalo');
      }

      return {intervalo: nota};
    }).toList();

    return intervalosMapeados;
  }

  @override
  String toString() => '$fundamental$tipo';
}
