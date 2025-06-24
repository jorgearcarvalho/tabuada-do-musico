import 'package:flutter/material.dart';
import 'package:tcc_app/widgets/caixinha_texto.dart';

class TeoriaIntervalosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estudando Intervalos'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CaixinhaTexto(
              title: 'O que é um intervalo?',
              description:
                  'Intervalo é a distância entre duas notas musicais. Ele pode ser medido em graus (2ª, 3ª, 4ª, etc.) e em tons e semitons.'
                  '\nVejamos os acidentes da escala de dó maior: \nC - C# - D - D# - E - F - F# - G - G# - A - A# - B',
            ),
            SizedBox(height: 16),
            CaixinhaTexto(
              title: 'Como contar um intervalo:',
              description: '1. Conte a nota de partida como “1”.\n'
                  '2. Vá subindo uma nota da escala até chegar na nota desejada.\n'
                  'Ex: De C até E = C(1), D(2), E(3) → intervalo de 3ª.',
            ),
            SizedBox(height: 16),
            CaixinhaTexto(
              title: 'Qualidade do intervalo:',
              description: 'Os intervalos podem ser:\n'
                  '• Justos (J): 1ª, 4ª, 5ª, 8ª\n'
                  '• Maiores (M) ou menores (m): 2ª, 3ª, 6ª, 7ª\n'
                  '• Aumentados (A) ou diminutos (d): se forem meio tom acima/abaixo do padrão.',
            ),
            SizedBox(height: 16),
            CaixinhaTexto(
                title: 'Dica!',
                description: 'Procure memorizar a distância entre duas notas.\n'
                    'Exemplos: \nC → E (2 tons de distância = Intervalo de terça maior).\n'
                    'D → F (1 tom e 1 semitom de distância = Intervalo de terça menor)'),
          ],
        ),
      ),
    );
  }
}
