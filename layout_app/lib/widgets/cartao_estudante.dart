import 'package:flutter/material.dart';

class CartaoEstudante extends StatelessWidget {
  final String nome;
  final String curso;
  final String matricula;
  final String email;
  final String imagem;

  const CartaoEstudante({
    super.key,
    required this.nome,
    required this.curso,
    required this.matricula,
    required this.email,
    required this.imagem,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20.0),

          // EXERCÍCIO 01
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
          ),

          child: Column(
            children: [
              CircleAvatar(
                radius: 45,

                // EXERCÍCIO 03
                foregroundImage: NetworkImage(imagem),
              ),

              const SizedBox(height: 12),

              Text(
                nome,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                curso,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // EXERCÍCIO 01
                  const Icon(
                    Icons.badge,
                    color: Colors.green,
                  ),

                  const SizedBox(width: 8),

                  Text('Matrícula: $matricula'),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // EXERCÍCIO 01
                  const Icon(
                    Icons.email,
                    color: Colors.green,
                  ),

                  const SizedBox(width: 8),

                  Text(email),
                ],
              ),

              const SizedBox(height: 8),

              // EXERCÍCIO 02
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),

                  const SizedBox(width: 8),

                  const Text(
                    'Status: Matriculado / Ativo',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}