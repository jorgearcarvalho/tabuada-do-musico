import 'package:flutter/material.dart';

class TeoriaAcordesPage extends StatelessWidget {
  const TeoriaAcordesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teoria: Acordes'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20),
        child: ListView(
          children: [
            Text(
              'O que é um Acorde?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Acordes são formados por três ou mais notas tocadas simultaneamente. A estrutura mais comum é a tríade, composta pela tônica (nota base), uma terça e uma quinta.',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(
              'Acorde Maior',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Fórmula: Tônica - Terça Maior - Quinta Justa\nExemplo em C (Dó): C - E - G',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(
              'Acorde menor',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Fórmula: Tônica - Terça menor - Quinta Justa\nExemplo em C (Dó menor): C - Eb - G',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(
              'Acorde suspenso (sus4)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Fórmula: Tônica - Quarta Justa - Quinta Justa\nExemplo em C: C - F - G',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(
              'Acorde aumentado (#5)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Fórmula: Tônica - Terça Maior - Quinta aumentada\nExemplo em C: C - E - G#',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(
              'Acorde com sétima maior (7M)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Fórmula: Tônica - Terça Maior - Quinta Justa - Sétima Maior\nExemplo em C: C - E - G - B',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(
              'Acorde com sétima menor (7)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Fórmula: Tônica - Terça Maior - Quinta Justa - Sétima menor\nExemplo em C: C - E - G - Bb',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(
              'Acorde menor com sétima menor (m7)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Fórmula: Tônica - Terça menor - Quinta Justa - Sétima menor\nExemplo em C: C - Eb - G - Bb',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(
              'Acorde menor com sétima maior (m7M)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Fórmula: Tônica - Terça menor - Quinta Justa - Sétima Maior\nExemplo em C: C - Eb - G - B',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(
              'Acorde meio-diminuto (m7b5)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Fórmula: Tônica - Terça menor - Quinta diminuta - Sétima menor\nExemplo em C: C - Eb - Gb - Bb',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(
              'Acorde diminuto (º)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Fórmula: Tônica - Terça menor - Quinta diminuta - Sétima diminuta\nExemplo em C: C - Eb - Gb - Bbb',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 16),
            Text(
              'Dica!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '- Use a fórmula correta para montar o acorde a partir da tônica.\n'
              '- Lembre-se dos intervalos entre as notas (2 semitons = 1 tom).\n'
              '- Fique atento à alteração de notas: sustenidos (#) ou bemóis (b).',
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
