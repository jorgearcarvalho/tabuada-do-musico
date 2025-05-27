import 'package:flutter/material.dart';
import 'package:tcc_app/widgets/caixinha_texto.dart'; // ajuste o caminho conforme necessário

class TeoriaEscalasPage extends StatelessWidget {
  const TeoriaEscalasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teoria: Escalas'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 20),
        child: ListView(
          children: const [
            CaixinhaTexto(
              title: 'O que é uma Escala?',
              description:
                  'Escalas são conjuntos de notas organizadas em uma ordem específica de tons e semitons. Elas são fundamentais para entender a tonalidade de uma música.',
            ),
            SizedBox(height: 16),
            CaixinhaTexto(
              title: 'Escala Maior',
              description:
                  'A fórmula da escala maior é: tom - tom - semitom - tom - tom - tom - semitom. Exemplo em C (Dó maior): \nC - D - E - F - G - A - B - C',
            ),
            SizedBox(height: 16),
            CaixinhaTexto(
              title: 'Escala Menor Harmônica',
              description:
                  'Fórmula: tom - semitom - tom - tom - semitom - 1 tom e meio - semitom. Exemplo em A (Lá menor harmônica):\nA - B - C - D - E - F - G# - A',
            ),
            SizedBox(height: 16),
            CaixinhaTexto(
              title: 'Escala Menor Melódica',
              description:
                  'Fórmula: tom - semitom - tom - tom - tom - tom - semitom (na subida). Exemplo em A: \nA - B - C - D - E - F# - G# - A',
            ),
            SizedBox(height: 16),
            CaixinhaTexto(
              title: 'Dica!',
              description:
                  '- Lembre-se de aplicar a fórmula da escala ao escolher as notas.\n'
                  '- Sempre comece pela tônica (a nota base da escala).\n'
                  '- Use sustenidos (#) ou bemóis (b) de acordo com a tonalidade sorteada.',
            ),
          ],
        ),
      ),
    );
  }
}
