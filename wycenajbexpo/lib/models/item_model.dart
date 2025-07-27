class ItemModel {
  final String category;
  final String name;
  final double quantity;
  final String unit;
  final double priceBrutto;

  ItemModel({
    required this.category,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.priceBrutto,
  });

  double get total => quantity * priceBrutto;
}
