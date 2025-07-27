import 'package:flutter/material.dart';
import '../widgets/category_selector.dart';
import '../widgets/summary_card.dart';
import '../models/item_model.dart';
import '../services/pdf_generator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<ItemModel> selectedItems = [];

  void addItem(ItemModel item) {
    setState(() {
      selectedItems.add(item);
    });
  }

  void generatePdf() {
    PdfGenerator.generateInvoice(selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Wycena stoiska targowego'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dodaj elementy do wyceny',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: CategorySelector(onItemSelected: addItem),
              ),
              const SizedBox(height: 24),
              if (selectedItems.isNotEmpty) ...[
                Text(
                  'Podsumowanie',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                SummaryCard(items: selectedItems),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: selectedItems.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: generatePdf,
              label: const Text('Generuj PDF'),
              icon: const Icon(Icons.picture_as_pdf),
              backgroundColor: Colors.deepPurple,
            )
          : null,
    );
  }
}
