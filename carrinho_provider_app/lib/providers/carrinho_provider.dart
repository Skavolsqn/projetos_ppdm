```dart
import 'package:flutter/foundation.dart';
import '../models/produto.dart';

class CarrinhoItem {
  final Produto produto;
  int quantidade;

  CarrinhoItem({
    required this.produto,
    this.quantidade = 1,
  });

  double get subtotal => produto.preco * quantidade;
}

class CarrinhoProvider extends ChangeNotifier {
  final List<CarrinhoItem> _itens = [];
  bool _cupomAplicado = false;

  List<CarrinhoItem> get itens => List.unmodifiable(_itens);

  int get quantidade {
    return _itens.fold(0, (total, item) => total + item.quantidade);
  }

  double get subtotal {
    return _itens.fold(0.0, (total, item) => total + item.subtotal);
  }

  bool get cupomAplicado => _cupomAplicado;

  double get desconto {
    return _cupomAplicado ? subtotal * 0.10 : 0.0;
  }

  double get valorTotal {
    return subtotal - desconto;
  }

  void adicionar(Produto produto) {
    final index = _itens.indexWhere(
      (item) => item.produto.id == produto.id,
    );

    if (index >= 0) {
      _itens[index].quantidade++;
    } else {
      _itens.add(CarrinhoItem(produto: produto));
    }

    notifyListeners();
  }

  void diminuir(Produto produto) {
    final index = _itens.indexWhere(
      (item) => item.produto.id == produto.id,
    );

    if (index >= 0) {
      if (_itens[index].quantidade > 1) {
        _itens[index].quantidade--;
      } else {
        _itens.removeAt(index);
      }
    }

    notifyListeners();
  }

  void remover(Produto produto) {
    _itens.removeWhere(
      (item) => item.produto.id == produto.id,
    );

    notifyListeners();
  }

  void aplicarCupom() {
    _cupomAplicado = true;
    notifyListeners();
  }

  void removerCupom() {
    _cupomAplicado = false;
    notifyListeners();
  }

  void limpar() {
    _itens.clear();
    _cupomAplicado = false;
    notifyListeners();
  }
}