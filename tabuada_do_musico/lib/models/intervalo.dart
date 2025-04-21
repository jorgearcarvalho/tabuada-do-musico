class Intervalo {
  final bool bloqueado;
  late int tempoAtual;
  late int melhorTempo;
  late int pontuacaoAtual;
  late int melhorPontuacao;

  Intervalo({
    required this.bloqueado,
    required medalha,
    required pontuacaoAtual,
    required melhorPontuacao,
  });

  factory Intervalo.fromJson(Map<String, dynamic> json) {
    return Intervalo(
        bloqueado: json['bloqueado'],
        medalha: json['medalha'],
        pontuacaoAtual: json['pontuacaoAtual'],
        melhorPontuacao: json['melhorPontuacao']);
  }
}
