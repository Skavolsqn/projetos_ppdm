import 'package:flutter/material.dart';

class CartaoEstudante extends StatelessWidget {
  final String nome;
  final String curso;
  final String ra;
  final String email;
  final String imagem;

  const CartaoEstudante({
    super.key,
    required this.nome,
    required this.curso,
    required this.ra,
    required this.email,
    required this.imagem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Colors.white,
            Color(0xFFE8F5E9),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [

            CircleAvatar(
              radius: 40,
              foregroundImage: NetworkImage(imagem),
            ),

            const SizedBox(height: 12),

            Text(
              nome,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            Text(
              curso,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),

            const Divider(
              height: 24,
              thickness: 1,
            ),

            Row(
              children: [
                const Icon(
                  Icons.badge,
                  color: Colors.green,
                ),

                const SizedBox(width: 10),

                Text(
                  'RA: $ra',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(
                  Icons.email,
                  color: Colors.green,
                ),

                const SizedBox(width: 10),

                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Text(
              'Sobre Mim',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              'Estudante de Desenvolvimento de Sistemas, '
              'interessado em programação mobile e criação de aplicativos.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              'Skills',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 8),

            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Chip(
                  label: Text('Flutter'),
                ),

                SizedBox(width: 5),

                Chip(
                  label: Text('Dart'),
                ),

                SizedBox(width: 5),

                Chip(
                  label: Text('Firebase'),
                ),

              ],
            ),

            const SizedBox(height: 16),

            const Row(
              children: [

                Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),

                SizedBox(width: 10),

                Text(
                  'Status: Matriculado / Ativo',
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),

              ],
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: () {},
              child: const Text(
                'Validar Carteirinha',
              ),
            ),
          ],
        ),
      ),
    );
  }
}