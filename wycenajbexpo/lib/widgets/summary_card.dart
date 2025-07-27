import 'package:flutter/material.dart';
import 'package:wycenajbexpo/data/category_color.dart';
import '../models/item_model.dart';

class SummaryCard extends StatelessWidget {
  final List<ItemModel> items;
  final void Function(ItemModel updatedItem, int index) onItemEdited;

  const SummaryCard({
    required this.items,
    required this.onItemEdited,
    super.key,
  });

  double get total => items.fold(0.0, (sum, item) => sum + item.total);

  void _showEditDialog(BuildContext context, ItemModel item, int index) {
    final quantityController =
        TextEditingController(text: item.quantity.toString());
    final priceController =
        TextEditingController(text: item.priceBrutto.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edytuj: ${item.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Ilość (${item.unit})'),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Cena brutto za jednostkę'),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Anuluj')),
          ElevatedButton(
            onPressed: () {
              final newQuantity =
                  double.tryParse(quantityController.text) ?? item.quantity;
              final newPrice =
                  double.tryParse(priceController.text) ?? item.priceBrutto;

              onItemEdited(
                ItemModel(
                  category: item.category,
                  name: item.name,
                  nameEn: item.nameEn,
                  quantity: newQuantity,
                  unit: item.unit,
                  priceBrutto: newPrice,
                ),
                index,
              );

              Navigator.pop(context);
            },
            child: const Text('Zapisz'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<ItemModel>> groupedItems = {};
    for (var item in items) {
      groupedItems.putIfAbsent(item.category, () => []).add(item);
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Podsumowanie', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            ...groupedItems.entries.map((entry) {
              final color = categoryColors[entry.key]?.withOpacity(0.1) ??
                  Colors.grey.withOpacity(0.1);
              final borderColor = categoryColors[entry.key] ?? Colors.grey;

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entry.key,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: borderColor,
                            fontSize: 16)),
                    const SizedBox(height: 8),
                    ...entry.value.map((item) {
                      final index = items.indexOf(item);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '- ${item.name} (${item.nameEn}): ${item.quantity} ${item.unit} × ${item.priceBrutto} zł = ${item.total.toStringAsFixed(2)} zł',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () =>
                                _showEditDialog(context, item, index),
                          )
                        ],
                      );
                    }),
                  ],
                ),
              );
            }),
            const Divider(),
            Text(
              'Razem: ${total.toStringAsFixed(2)} zł',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
