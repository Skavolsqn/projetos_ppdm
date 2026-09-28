import 'package:flutter/material.dart';
import 'cartao_estudante.dart';
 
void main() {
  runApp(const MeuCrachaApp());
}
 
class MeuCrachaApp extends StatelessWidget {
  const MeuCrachaApp({super.key});
 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PPDM - Crachá Digital',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const TelaCracha(),
    );
  }
}
 
class TelaCracha extends StatelessWidget {
  const TelaCracha({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PPDM - Identificação Estudantil'),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: const Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: CartaoEstudante(
            nome: 'Ana Silva Santos',
            curso: 'Desenvolvimento Mobile / PPDM',
            ra: '2026109923',
            email: 'ana.silva@estudante.edu.br',
            imagem:
                'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=300',
          ),
        ),
      ),
    );
  }
}