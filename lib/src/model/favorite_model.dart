class Favorite {
  int id;
  int userId;
  int productId;

  Favorite({
    this.id = 0,
    required this.productId,
    required this.userId,
  });

  factory Favorite.fromMap(Map<String, dynamic> data) {
    return Favorite(
      id: data['id'],
      productId: data['productId'],
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toPostgres() {
    return {
      'productId': productId,
      'userId': userId,
    };
  }
}
