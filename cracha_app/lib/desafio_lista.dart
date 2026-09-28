import 'package:flutter/material.dart';
import 'widgets/cartao_estudante.dart';

class DesafioLista extends StatelessWidget {
  const DesafioLista({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PPDM - Identificação Estudantil"),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: const Column(
          children: [
            CartaoEstudante(
              nome: "Ana Silva Santos",
              curso: "Desenvolvimento Mobile / PPDM",
              ra: "2026109923",
              email: "ana.silva@estudante.edu.br",
              imagem:
                  "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=300",
            ),

            SizedBox(height: 20),

            CartaoEstudante(
              nome: "Carlos Oliveira",
              curso: "Desenvolvimento Mobile / PPDM",
              ra: "2026109924",
              email: "carlos.oliveira@estudante.edu.br",
              imagem:
                  "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=300",
            ),

            SizedBox(height: 20),

            CartaoEstudante(
              nome: "Mariana Costa",
              curso: "Desenvolvimento Mobile / PPDM",
              ra: "2026109925",
              email: "mariana.costa@estudante.edu.br",
              imagem:
                  "https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=300",
            ),
          ],
        ),
      ),
    );
  }
}