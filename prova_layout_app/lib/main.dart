import 'package:flutter/material.dart';
// Desafio 7: import do widget customizado
import 'widgets/bloco_estatistica.dart';

void main() {
  runApp(const MeuLayoutApp());
}

class MeuLayoutApp extends StatelessWidget {
  const MeuLayoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PPDM - Avaliação 02 (Layout Widgets)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const TelaDashboard(),
    );
  }
}

class TelaDashboard extends StatelessWidget {
  const TelaDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PPDM - Dashboard de Observações'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Desafio 2: crossAxisAlignment alterado de .start para .center
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Resumo das Observações',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),

            // Desafio 7: primeira linha componentizada com BlocoEstatistica
            // (Desafio 1: 3º card com Expanded para dividir o espaço
            // igualmente entre os 3)
            Row(
              children: [
                Expanded(
                  child: BlocoEstatistica(
                    icone: Icons.flutter_dash,
                    valor: '124',
                    rotulo: 'Aves Vistas',
                    corFundo: Colors.teal.shade100,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: BlocoEstatistica(
                    icone: Icons.place,
                    valor: '18',
                    rotulo: 'Locais Visitados',
                    corFundo: Colors.teal.shade50,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: BlocoEstatistica(
                    icone: Icons.camera_alt,
                    valor: '45',
                    rotulo: 'Fotos',
                    corFundo: Colors.teal.shade200,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24.0),

            const Text(
              'Resumo em Grade',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),

            // Desafio 8: layout em grade 2x2 com GridView.count.
            // crossAxisCount: 2 define as 2 colunas (4 itens = 2 linhas).
            // shrinkWrap e NeverScrollableScrollPhysics permitem usar a grade
            // dentro da Column/SingleChildScrollView sem erro de altura.
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                mainAxisSpacing: 12.0,
                childAspectRatio: 1.3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  BlocoEstatistica(
                    icone: Icons.flutter_dash,
                    valor: '124',
                    rotulo: 'Aves Vistas',
                    corFundo: Colors.teal.shade100,
                  ),
                  BlocoEstatistica(
                    icone: Icons.place,
                    valor: '18',
                    rotulo: 'Locais Visitados',
                    corFundo: Colors.teal.shade50,
                  ),
                  BlocoEstatistica(
                    icone: Icons.camera_alt,
                    valor: '45',
                    rotulo: 'Fotos',
                    corFundo: Colors.teal.shade200,
                  ),
                  BlocoEstatistica(
                    icone: Icons.calendar_today,
                    valor: '32',
                    rotulo: 'Dias de Campo',
                    corFundo: Colors.teal.shade100,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            const Text(
              'Destaque da Semana',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),

            Stack(
              clipBehavior: Clip.none,
              children: [
                // Desafio 6: Container substituído por Card do Material com
                // elevation: 4
                Card(
                  elevation: 4,
                  margin: EdgeInsets.zero,
                  color: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        const Icon(Icons.star, size: 48, color: Colors.amber),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Gavião-Real', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text('Avistado no Parque Central', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: -8,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Raro',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // Desafio 5: 2º selo "Confirmado" (verde) sobreposto no canto
                // inferior esquerdo do Stack com Positioned
                Positioned(
                  bottom: -8,
                  left: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Confirmado',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24.0),

            // Desafio 3: seção "Últimos Registros" com Row e
            // MainAxisAlignment.spaceBetween
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.list, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(
                        'Últimos Registros',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.teal),
                ],
              ),
            ),
            const SizedBox(height: 24.0),

            // Desafio 4: erro de overflow (RenderFlex overflow).
            // Código que causa o erro (comentado):
            // Row(
            //   children: const [
            //     Icon(Icons.info, color: Colors.teal),
            //     SizedBox(width: 8),
            //     Text(
            //       'Este é um texto de observação muito longo que não cabe '
            //       'na largura da tela e causa overflow na Row',
            //     ),
            //   ],
            // ),
            // Correção: Text envolvido em Expanded.
            Row(
              children: const [
                Icon(Icons.info, color: Colors.teal),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Este é um texto de observação muito longo que não cabe '
                    'na largura da tela e causa overflow na Row',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
