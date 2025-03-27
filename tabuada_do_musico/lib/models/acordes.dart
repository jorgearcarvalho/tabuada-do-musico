class Acorde {
  final String fundamental;
  final String tipo;

  static const List<String> escalaCromatica = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B'
  ];

  static const Map<String, List<int>> triades = {
    'Aaior': [0, 4, 7],
    'menor': [0, 3, 7],
    'Aum': [0, 4, 8],
    'dim': [0, 3, 6],
    'sus4': [0, 5, 7],
  };

  static const Map<String, List<int>> tetrades = {
    'maj7': [0, 4, 7, 11],
    '7': [0, 4, 7, 10],
    'min7': [0, 3, 7, 10],
    'm7b5': [0, 3, 6, 10],
    'dim7': [0, 3, 6, 9],
  };

  static Map<String, List<int>> get formulas => {
        ...triades,
        ...tetrades,
      };

  Acorde(this.fundamental, this.tipo);

  List<String> get notas {
    final rootIndex = escalaCromatica.indexOf(fundamental);
    if (rootIndex == -1)
      throw Exception('Nota fundamental inválida: $fundamental');
    final intervals = formulas[tipo];
    if (intervals == null)
      throw Exception('Tipo de acorde desconhecido: $tipo');

    return intervals.map((i) {
      return escalaCromatica[(rootIndex + i) % 12];
    }).toList();
  }

  @override
  String toString() => '$fundamental$tipo (${notas.join(', ')})';
}
