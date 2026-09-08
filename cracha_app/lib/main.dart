```dart
import 'package:flutter/material.dart';
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
      title: 'PPDM - Layout Widgets',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
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
        title: const Text('PPDM - Dashboard de Observacoes'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          // EXERCICIO 02
          // Alterado de CrossAxisAlignment.start
          // para CrossAxisAlignment.center
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            const Text(
              'Resumo das Observacoes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16.0),

            // EXERCICIO 08
            // GridView.count substituindo Row/Expanded
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),

              children: const [
                // EXERCICIO 07
                BlocoEstatistica(
                  icone: Icons.flutter_dash,
                  valor: '124',
                  legenda: 'Aves Vistas',
                  cor: Color(0xFFE0F2F1),
                ),

                BlocoEstatistica(
                  icone: Icons.place,
                  valor: '181',
                  legenda: 'Locais Visitados',
                  cor: Color(0xFFE0F2F1),
                ),

                // EXERCICIO 01
                BlocoEstatistica(
                  icone: Icons.camera_alt,
                  valor: '45',
                  legenda: 'Fotos',
                  cor: Color(0xFFE0F2F1),
                ),

                // Quarto card para completar a grade 2x2
                BlocoEstatistica(
                  icone: Icons.favorite,
                  valor: '32',
                  legenda: 'Favoritos',
                  cor: Color(0xFFE0F2F1),
                ),
              ],
            ),

            const SizedBox(height: 24.0),

            const Text(
              'Destaque da Semana',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16.0),

            // EXERCICIO 05
            // Stack com dois selos sobrepostos
            Stack(
              clipBehavior: Clip.none,
              children: [
                // EXERCICIO 06
                // Container substituido por Card
                Card(
                  elevation: 4,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20.0),

                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 48,
                          color: Colors.amber,
                        ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Gaviao-Real',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Text(
                                'Avistado no Parque Central',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Selo "Raro"
                Positioned(
                  top: -8,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: const Text(
                      'Raro',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // EXERCICIO 05
                // Segundo selo: Confirmado
                Positioned(
                  bottom: -8,
                  left: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: const Text(
                      'Confirmado',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32.0),

            // EXERCICIO 03
            const Text(
              'Ultimos Registros',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16.0),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),

              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.list,
                        color: Colors.teal,
                        size: 30,
                      ),

                      SizedBox(width: 12),

                      Text(
                        'Visualizar registros recentes',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Ver'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
