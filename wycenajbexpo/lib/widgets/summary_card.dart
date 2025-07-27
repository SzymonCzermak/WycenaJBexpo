import 'package:flutter/material.dart';
import '../models/item_model.dart';

class SummaryCard extends StatelessWidget {
  final List<ItemModel> items;

  const SummaryCard({required this.items, super.key});

  double get total => items.fold(0.0, (sum, item) => sum + item.total);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Podsumowanie', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            ...items.map((item) => Text(
              '- ${item.name}: ${item.quantity} ${item.unit} × ${item.priceBrutto} zł = ${item.total.toStringAsFixed(2)} zł',
            )),
            const Divider(),
            Text('Razem: ${total.toStringAsFixed(2)} zł', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
