import 'package:flutter/material.dart';

class TeoriaIntervalosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teoria: Intervalos Musicais'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'O que é um intervalo?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Intervalo é a distância entre duas notas musicais. Ele pode ser medido em graus (2ª, 3ª, 4ª, etc.) e em tons e semitons.',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(
              'Como contar um intervalo:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '1. Conte a nota de partida como “1”.\n'
              '2. Vá subindo uma nota da escala até chegar na nota desejada.\n'
              'Ex: De C até E = C(1), D(2), E(3) → intervalo de 3ª.',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(
              'Qualidade do intervalo:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Os intervalos podem ser:\n'
              '• Justos (J): 4ª, 5ª, 8ª\n'
              '• Maiores (M) ou menores (m): 2ª, 3ª, 6ª, 7ª\n'
              '• Aumentados (A) ou diminutos (d): se forem meio tom acima/abaixo do padrão.',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(
              'Dica!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Memorize os sons dos intervalos com músicas conhecidas.\n'
              'Ex: C → E (3ª maior) lembra o início de "Aquarela" de Toquinho.\n'
              'Use isso para fortalecer sua percepção auditiva.',
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
