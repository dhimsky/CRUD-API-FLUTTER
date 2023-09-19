class Book {
  final BigInt id;
  final String name;
  final int price;
  final String desc;

  Book({
    required this.id,
    required this.name,
    required this.price,
    required this.desc,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: BigInt.tryParse(json['id'].toString()) ?? BigInt.zero,
      name: json['name'] as String? ?? '',
      price: int.tryParse(json['price'].toString()) ?? 0,
      desc: json['desc'] as String? ?? '',
    );
  }
}
