Map<String, List<int>> formulaTriades = {
  'maior': [0, 4, 7], // tríade maior: 1, 3M, 5J
  'menor': [0, 3, 7], // tríade menor: 1, 3m, 5J
  'aum': [0, 4, 8], // tríade aumentada: 1, 3M, #5
  'dim': [0, 3, 6], // tríade diminuta: 1, 3m, b5
  'sus4': [0, 5, 7], // tríade suspensa 4: 1, 4, 5
};

Map<String, List<int>> formulaTetrades = {
  'maj7': [0, 4, 7, 11], // maior com 7M: 1, 3M, 5J, 7M
  '7': [0, 4, 7, 10], // dominante: 1, 3M, 5J, 7m
  'min7': [0, 3, 7, 10], // menor com 7m: 1, 3m, 5J, 7m
  'm7b5': [0, 3, 6, 10], // meio diminuto: 1, 3m, b5, 7m
  'dim': [0, 3, 6, 9], // diminuto: 1, 3m, b5, 6 (ou 7bb)
};
