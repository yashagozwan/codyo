class Product {
  int id;
  String imageUrl;
  String title;
  String description;
  int price;
  bool isSold;
  double latitude;
  double longitude;
  int createdAt;
  int userId;

  Product({
    this.id = 0,
    this.imageUrl = 'com.yashagozwan.codyo',
    required this.title,
    required this.description,
    required this.price,
    this.isSold = false,
    required this.latitude,
    required this.longitude,
    this.createdAt = 0,
    this.userId = 0,
  });

  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      id: data['id'],
      imageUrl: data['imageUrl'],
      title: data['title'],
      description: data['description'],
      price: data['price'],
      isSold: data['isSold'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      createdAt: data['createdAt'],
      userId: data['userId'],
    );
  }

  Map<String, dynamic> toPostgres() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'description': description,
      'price': price,
      'isSold': isSold,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': DateTime.now().millisecondsSinceEpoch,
      'userId': userId,
    };
  }

  Map<String, dynamic> toPostgresUpdate() {
    return {
      'imageUrl': imageUrl,
      'title': title,
      'description': description,
      'price': price,
      'isSold': isSold,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': createdAt,
      'userId': userId,
    };
  }
}
