import 'package:flutter/material.dart';
import 'package:tcc_app/widgets/caixinha_texto.dart';

class TeoriaAcordesPage extends StatelessWidget {
  const TeoriaAcordesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estudando Acordes'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20),
        child: ListView(
          children: const [
            CaixinhaTexto(
              title: 'O que é um Acorde?',
              description:
                  'Acordes são formados por três ou mais notas tocadas simultaneamente. A estrutura mais comum é a tríade, composta pela tônica (nota base), uma terça e uma quinta. Há também as tétrades, formadas por uma tríade acrescida de um intervalo de 7ª.',
            ),
            SizedBox(height: 16),
            CaixinhaTexto(
              title: 'Acorde Maior',
              description:
                  'Fórmula: Tônica + Terça Maior + Quinta Justa\nExemplo em C (Dó): C + E + G',
            ),
            SizedBox(height: 16),
            CaixinhaTexto(
              title: 'Acorde menor',
              description:
                  'Fórmula: Tônica + Terça menor + Quinta Justa\nExemplo em C (Dó menor): C + Eb + G',
            ),
            SizedBox(height: 16),
            CaixinhaTexto(
              title: 'Acorde suspenso (sus4)',
              description:
                  'Fórmula: Tônica + Quarta Justa + Quinta Justa\nExemplo em C: C + F + G',
            ),
            SizedBox(height: 16),
            CaixinhaTexto(
              title: 'Acorde aumentado (#5)',
              description:
                  'Fórmula: Tônica + Terça Maior + Quinta aumentada\nExemplo em C: C + E + G#',
            ),
            SizedBox(height: 16),
            CaixinhaTexto(
              title: 'Acorde com sétima maior (7M)',
              description:
                  'Fórmula: Tônica + Terça Maior + Quinta Justa + Sétima Maior\nExemplo em C: C + E + G + B',
            ),
            SizedBox(height: 16),
            CaixinhaTexto(
              title: 'Acorde com sétima menor (7)',
              description:
                  'Fórmula: Tônica + Terça Maior + Quinta Justa + Sétima menor\nExemplo em C: C + E + G + Bb',
            ),
            SizedBox(height: 16),
            CaixinhaTexto(
              title: 'Acorde menor com sétima menor (m7)',
              description:
                  'Fórmula: Tônica + Terça menor + Quinta Justa + Sétima menor\nExemplo em C: C + Eb + G + Bb',
            ),
            SizedBox(height: 16),
            CaixinhaTexto(
              title: 'Acorde menor com sétima maior (m7M)',
              description:
                  'Fórmula: Tônica + Terça menor + Quinta Justa + Sétima Maior\nExemplo em C: C + Eb + G + B',
            ),
            SizedBox(height: 16),
            CaixinhaTexto(
              title: 'Acorde meio diminuto (m7b5)',
              description:
                  'Fórmula: Tônica + Terça menor + Quinta diminuta + Sétima menor\nExemplo em C: C + Eb + Gb + Bb',
            ),
            SizedBox(height: 16),
            CaixinhaTexto(
              title: 'Acorde diminuto (º)',
              description:
                  'Fórmula: Tônica + Terça menor + Quinta diminuta + Sétima diminuta\nExemplo em C: C + Eb + Gb + Bbb',
            ),
            SizedBox(height: 16),
            CaixinhaTexto(
              title: 'Dica!',
              description:
                  '- Use a fórmula correta para montar o acorde a partir da tônica.\n'
                  '- Lembre-se dos intervalos entre as notas (2 semitons = 1 tom).\n'
                  '- Fique atento à alteração de notas: sustenidos (#) ou bemóis (b).',
            ),
          ],
        ),
      ),
    );
  }
}
