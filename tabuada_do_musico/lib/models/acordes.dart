import 'package:tcc_app/database/tonalidades/bemois.dart';
import 'package:tcc_app/database/tonalidades/sustenidos.dart';
import 'package:tcc_app/database/tonalidades/naturais.dart';

class Acorde {
  final String fundamental;
  final String tipo;

  static const Map<String, List<String>> triades = {
    '': ['1J', '3M', '5J'],
    'm': ['1J', '3m', '5J'],
    '5+': ['1J', '3M', '5A'],
    'sus4': ['1J', '4J', '5J']
  };

  static const Map<String, List<String>> tetrades = {
    '7M': ['1J', '3M', '5J', '7M'],
    '7': ['1J', '3M', '5J', '7m'],
    'm7': ['1J', '3m', '5J', '7m'],
    'm7M': ['1J', '3m', '5J', '7M'],
    'm7b5': ['1J', '3m', '5d', '7m'],
    '°': ['1J', '3m', '5d', '7d'],
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
