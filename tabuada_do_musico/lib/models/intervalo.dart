class Intervalo {
  final bool bloqueado;
  late int tempoAtual;
  late int melhorTempo;
  late int pontuacaoAtual;
  late int melhorPontuacao;

  Intervalo({
    required this.bloqueado,
    required tempoAtual,
    required melhorTempo,
    required pontuacaoAtual,
    required melhorPontuacao,
  });

  factory Intervalo.fromJson(Map<String, dynamic> json) {
    return Intervalo(
        bloqueado: json['bloqueado'],
        tempoAtual: json['tempoAtual'],
        melhorTempo: json['melhorTempo'],
        pontuacaoAtual: json['pontuacaoAtual'],
        melhorPontuacao: json['melhorPontuacao']);
  }
}
