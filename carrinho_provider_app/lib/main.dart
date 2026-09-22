```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/produto.dart';
import 'providers/carrinho_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CarrinhoProvider(),
      child: const CarrinhoApp(),
    ),
  );
}

class CarrinhoApp extends StatelessWidget {
  const CarrinhoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carrinho com Provider',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        useMaterial3: true,
      ),
      home: const CatalogoScreen(),
    );
  }
}

class CatalogoScreen extends StatelessWidget {
  const CatalogoScreen({super.key});

  static const List<Produto> produtos = [
    Produto(
      id: '1',
      nome: 'Teclado Mecânico',
      preco: 250.00,
    ),
    Produto(
      id: '2',
      nome: 'Mouse Gamer',
      preco: 120.00,
    ),
    Produto(
      id: '3',
      nome: 'Monitor 24"',
      preco: 890.00,
    ),
    Produto(
      id: '4',
      nome: 'Headset Stereo',
      preco: 180.00,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CarrinhoScreen(),
                    ),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Consumer<CarrinhoProvider>(
                  builder: (context, carrinho, child) {
                    if (carrinho.quantidade == 0) {
                      return const SizedBox();
                    }

                    return CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.red,
                      child: Text(
                        '${carrinho.quantidade}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          final produto = produtos[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(
              title: Text(
                produto.nome,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'R\$ ${produto.preco.toStringAsFixed(2)}',
              ),
              trailing: Consumer<CarrinhoProvider>(
                builder: (context, carrinho, child) {
                  final item = carrinho.itens.where(
                    (item) => item.produto.id == produto.id,
                  );

                  final quantidade = item.isNotEmpty
                      ? item.first.quantidade
                      : 0;

                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (quantidade > 0)
                        IconButton(
                          icon: const Icon(
                            Icons.remove_circle_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            carrinho.diminuir(produto);
                          },
                        ),
                      if (quantidade > 0)
                        Text(
                          '$quantidade',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      IconButton(
                        icon: const Icon(
                          Icons.add_shopping_cart,
                          color: Colors.teal,
                        ),
                        onPressed: () {
                          carrinho.adicionar(produto);
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class CarrinhoScreen extends StatelessWidget {
  const CarrinhoScreen({super.key});

  Future<void> confirmarLimpeza(BuildContext context) async {
    final carrinho = context.read<CarrinhoProvider>();

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Limpar carrinho'),
          content: const Text(
            'Tem certeza que deseja limpar todos os produtos do carrinho?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      carrinho.limpar();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Carrinho limpo com sucesso!'),
          ),
        );
      }
    }
  }

  Future<void> finalizarCompra(BuildContext context) async {
    final carrinho = context.read<CarrinhoProvider>();

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Finalizar compra'),
          content: Text(
            'Deseja finalizar a compra no valor de '
            'R\$ ${carrinho.valorTotal.toStringAsFixed(2)}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Finalizar'),
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      carrinho.limpar();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Compra finalizada com sucesso!',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seu Carrinho'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          Consumer<CarrinhoProvider>(
            builder: (context, carrinho, child) {
              if (carrinho.quantidade == 0) {
                return const SizedBox();
              }

              return IconButton(
                icon: const Icon(Icons.delete_sweep),
                onPressed: () {
                  confirmarLimpeza(context);
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<CarrinhoProvider>(
        builder: (context, carrinho, child) {
          if (carrinho.quantidade == 0) {
            return const Center(
              child: Text(
                'Seu carrinho está vazio!',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: carrinho.itens.length,
                  itemBuilder: (context, index) {
                    final item = carrinho.itens[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        title: Text(
                          item.produto.nome,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'R\$ ${item.produto.preco.toStringAsFixed(2)} cada\n'
                          'Subtotal: R\$ ${item.subtotal.toStringAsFixed(2)}',
                        ),
                        isThreeLine: true,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                carrinho.diminuir(item.produto);
                              },
                            ),
                            Text(
                              '${item.quantidade}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                carrinho.adicionar(item.produto);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.teal.shade50,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Subtotal:',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'R\$ ${carrinho.subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    if (carrinho.cupomAplicado)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Desconto (10%):',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            '- R\$ ${carrinho.desconto.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'R\$ ${carrinho.valorTotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: carrinho.cupomAplicado
                                ? null
                                : () {
                                    carrinho.aplicarCupom();

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Cupom de 10% aplicado!',
                                        ),
                                      ),
                                    );
                                  },
                            child: Text(
                              carrinho.cupomAplicado
                                  ? 'Cupom aplicado'
                                  : 'Aplicar cupom 10%',
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              finalizarCompra(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Finalizar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}