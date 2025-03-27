Map<String, List<String>> formulaTriades = {
  'maior': ['1J', '3M', '5J'],
  'menor': ['1J', '3m', '5J'],
  'aum': ['1J', '3M', '5A'],
  'dim': ['1J', '3m', '5d'],
  'sus4': ['1J', '4J', '5J']
};

Map<String, List<String>> formulaTetrades = {
  'maj7': ['1J', '3M', '5J', '7M'], // maior com 7M: 1, 3M, 5J, 7M
  '7': ['1J', '3M', '5J', '7m'], // dominante: 1, 3M, 5J, 7m
  'min7': ['1J', '3m', '5J', '7m'], // menor com 7m: 1, 3m, 5J, 7m
  'm7b5': ['1J', '3m', '5d', '7m'], // meio diminuto: 1, 3m, b5, 7m
  'dim': ['1J', '3m', '5d', '6M'], // diminuto: 1, 3m, b5, 6 (ou 7bb)
};
