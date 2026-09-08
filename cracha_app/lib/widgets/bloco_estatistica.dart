```dart
import 'package:flutter/material.dart';

class BlocoEstatistica extends StatelessWidget {
  final IconData icone;
  final String valor;
  final String legenda;
  final Color cor;

  const BlocoEstatistica({
    super.key,
    required this.icone,
    required this.valor,
    required this.legenda,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: cor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icone,
              size: 36,
              color: Colors.teal,
            ),
            const SizedBox(height: 8),
            Text(
              valor,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              legenda,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```
