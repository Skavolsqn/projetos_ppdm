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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        // Exercício 04: fundo gradiente (não usar "color" junto com "gradient")
        gradient: const LinearGradient(
          colors: [
            Colors.white,
            Color.fromARGB(255, 220, 255, 220),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Exercício 01: imagem real com NetworkImage
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.green,
            foregroundImage: NetworkImage(imagem),
            // Aparece só se a imagem não carregar
            child: const Icon(Icons.person, size: 40, color: Colors.white),
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
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
 
          const Divider(height: 24),
 
          Row(
            children: [
              const Icon(Icons.badge, color: Colors.green),
              const SizedBox(width: 10),
              Text('RA: $ra', style: const TextStyle(fontSize: 16)),
            ],
          ),
 
          const SizedBox(height: 8),
 
          Row(
            children: [
              const Icon(Icons.email, color: Colors.green),
              const SizedBox(width: 10),
              Expanded(child: Text(email)),
            ],
          ),
 
          const SizedBox(height: 20),
 
          // Exercício 02: seção "Sobre Mim"
          const Text(
            'Sobre Mim',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
 
          const SizedBox(height: 8),
 
          const Text(
            'Sou estudante de Desenvolvimento Mobile, '
            'gosto de tecnologia, programação e criação '
            'de aplicativos utilizando Flutter.',
            textAlign: TextAlign.center,
          ),
 
          const SizedBox(height: 15),
 
          // Exercício 03: badges de skills com Chip dentro de uma Row
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
              Chip(label: Text('Flutter')),
              SizedBox(width: 5),
              Chip(label: Text('Dart')),
              SizedBox(width: 5),
              Chip(label: Text('Firebase')),
            ],
          ),
 
          const SizedBox(height: 15),
 
          ElevatedButton(
            onPressed: () {},
            child: const Text('Validar Carteirinha'),
          ),
        ],
      ),
    );
  }
}