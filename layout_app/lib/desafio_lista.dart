import 'package:flutter/material.dart';
import 'widgets/cartao_estudante.dart';

class DesafioLista extends StatelessWidget {
  const DesafioLista({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crachás dos Estudantes'),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          children: [
            const CartaoEstudante(
              nome: 'Ronaldo Rodrigues',
              curso: 'Programação para Dispositivos Móveis',
              matricula: '2026001',
              email: 'ronaldo@email.com',
              imagem: 'https://i.pravatar.cc/300?img=12',
            ),

            const SizedBox(height: 16),

            const CartaoEstudante(
              nome: 'João Silva',
              curso: 'Desenvolvimento de Sistemas',
              matricula: '2026002',
              email: 'joao@email.com',
              imagem: 'https://i.pravatar.cc/300?img=13',
            ),

            const SizedBox(height: 16),

            const CartaoEstudante(
              nome: 'Maria Santos',
              curso: 'Programação para Dispositivos Móveis',
              matricula: '2026003',
              email: 'maria@email.com',
              imagem: 'https://i.pravatar.cc/300?img=47',
            ),

            const SizedBox(height: 20),

            // EXERCÍCIO 06
            ElevatedButton(
              onPressed: () {},
              child: const Text('Validar Carteirinha'),
            ),
          ],
        ),
      ),
    );
  }
}