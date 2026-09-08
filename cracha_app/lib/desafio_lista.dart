import 'package:flutter/material.dart';
import 'cartao_estudante.dart';

class DesafioLista extends StatelessWidget {
  const DesafioLista({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PPDM - Identificação Estudantil',
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 16),

              CartaoEstudante(
                nome: 'Ana Silva Santos',
                curso: 'Desenvolvimento Mobile / PPDM',
                ra: '2026109923',
                email: 'ana.silva@estudante.edu.br',
                imagem: 'https://i.pravatar.cc/150?img=47',
              ),

              const SizedBox(height: 16),

              CartaoEstudante(
                nome: 'Carlos Oliveira',
                curso: 'Desenvolvimento de Sistemas',
                ra: '2026109924',
                email: 'carlos.oliveira@estudante.edu.br',
                imagem: 'https://i.pravatar.cc/150?img=12',
              ),

              const SizedBox(height: 16),

              CartaoEstudante(
                nome: 'Mariana Souza',
                curso: 'Programação Mobile / PPDM',
                ra: '2026109925',
                email: 'mariana.souza@estudante.edu.br',
                imagem: 'https://i.pravatar.cc/150?img=32',
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}