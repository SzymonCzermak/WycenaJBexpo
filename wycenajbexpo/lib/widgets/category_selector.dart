import 'package:flutter/material.dart';
import '../data/pricing_data.dart';
import '../models/item_model.dart';

class CategorySelector extends StatefulWidget {
  final Function(ItemModel) onItemSelected;

  const CategorySelector({required this.onItemSelected, super.key});

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  String? selectedCategory;
  Map<String, dynamic>? selectedOption;
  double quantity = 1;
  double priceBrutto = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          hint: const Text('Wybierz kategorię'),
          value: selectedCategory,
          isExpanded: true,
          items: pricingOptions.keys.map((String key) {
            return DropdownMenuItem<String>(
              value: key,
              child: Text(key),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedCategory = value;
              selectedOption = null;
              quantity = 1;
              priceBrutto = 0;
            });
          },
        ),
        if (selectedCategory != null)
          DropdownButton<Map<String, dynamic>>(
            hint: const Text('Wybierz opcję'),
            value: selectedOption,
            isExpanded: true,
            items: pricingOptions[selectedCategory]!.map((option) {
              return DropdownMenuItem<Map<String, dynamic>>(
                value: option,
                child: Text(option['name']),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedOption = value;
                priceBrutto = value?['priceBrutto'] ?? 0;
              });
            },
          ),
        if (selectedOption != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: Column(
              children: [
                TextFormField(
                  initialValue: quantity.toString(),
                  decoration: InputDecoration(
                    labelText: 'Ilość (${selectedOption!['unit']})',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      quantity = double.tryParse(value) ?? 1;
                    });
                  },
                ),
                const SizedBox(height: 8),
                TextFormField(
                  initialValue: priceBrutto.toString(),
                  decoration: const InputDecoration(
                    labelText: 'Cena brutto za jednostkę (zł)',
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      priceBrutto = double.tryParse(value) ?? 0;
                    });
                  },
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    final item = ItemModel(
                      category: selectedCategory!,
                      name: selectedOption!['name'],
                      nameEn: selectedOption!['nameEn'], // ← TO JEST KLUCZOWE!
                      quantity: quantity,
                      unit: selectedOption!['unit'],
                      priceBrutto: priceBrutto,
                    );
                    widget.onItemSelected(item);
                    setState(() {
                      selectedCategory = null;
                      selectedOption = null;
                      quantity = 1;
                      priceBrutto = 0;
                    });
                  },
                  child: const Text('Dodaj'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
