class CreateProductDTO {
  final String name;
  final String? imageUrl;
  final double price;
  final int amount;

  CreateProductDTO({
    required this.name,
    this.imageUrl,
    required this.price,
    required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'amount': amount,
    };
  }
}
