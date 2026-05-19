class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String image;
  final String category;

  bool isFavorite;
  bool isInCart;
  int quantity;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.image,
    required this.category,

    this.isFavorite = false,
    this.isInCart = false,
    this.quantity = 1,
  });

  factory Product.fromJson(
    Map<String, dynamic> json,
  ) {
    return Product(
      id: json['id'] ?? "",

      title:
          json['title'] ?? "",

      description:
          json['description'] ?? "",

      price:
          (json['price'] as num)
              .toDouble(),

      image:
          json['image'] ?? "",

      category:
          json['category'] ?? "",

      isFavorite:
          json['isFavorite']
              ?? false,

      isInCart:
          json['isInCart']
              ?? false,

      quantity:
          json['quantity']
              ?? 1,
    );
  }

  Map<String, dynamic>
      toJson() {
    return {
      "id": id,

      "title": title,

      "description":
          description,

      "price": price,

      "image": image,

      "category":
          category,

      "isFavorite":
          isFavorite,

      "isInCart":
          isInCart,

      "quantity":
          quantity,
    };
  }
}