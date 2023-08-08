import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shopee/models/model.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/services.dart';

enum ProductType {
  Electronics,
  Books,
  Fashion,
  Groceries,
  Art,
  Others,
}

class Product extends Model {
  static const String IMAGES_KEY = "images";
  static const String TITLE_KEY = "title";
  static const String VARIANT_KEY = "variant";
  static const String DISCOUNT_PRICE_KEY = "discount_price";
  static const String ORIGINAL_PRICE_KEY = "original_price";
  static const String RATING_KEY = "rating";
  static const String HIGHLIGHTS_KEY = "highlights";
  static const String DESCRIPTION_KEY = "description";
  static const String SELLER_KEY = "seller";
  static const String OWNER_KEY = "owner";
  static const String PRODUCT_TYPE_KEY = "product_type";
  static const String SEARCH_TAGS_KEY = "search_tags";
  static const String Quantity = "Quantity";

  List<String>? images;
  String? title;
  String? variant;
  num? discountPrice;
  num? originalPrice;
  num? quantity;
  num rating;
  String? highlights;
  String? description;
  String? seller;
  late bool favourite;
  String? owner;
  ProductType? productType;
  List<String>? searchTags;

  Product(
      String? id, {
        this.images,
        this.title,
        this.variant,
        this.productType,
        this.discountPrice,
        this.originalPrice,
        this.rating = 0.0,
        this.highlights,
        this.description,
        this.seller,
        this.owner,
        this.searchTags,
        this.quantity,
      }) : super(id!) {
    favourite = false; // Initializing the favourite field to false
  }

  int calculatePercentageDiscount() {
    if (originalPrice == null || discountPrice == null || originalPrice! <= discountPrice!) {
      return 0;
    }
    int discount = ((1 - (discountPrice! / originalPrice!)) * 100).round();
    return discount;
  }


  factory Product.fromMap(Map<String, dynamic> map, {required String id}) {
    return Product(
      id,
      images: (map[IMAGES_KEY] as List?)?.cast<String>(),
      title: map[TITLE_KEY],
      variant: map[VARIANT_KEY],
      productType: EnumToString.fromString(ProductType.values, map[PRODUCT_TYPE_KEY]),
      discountPrice: map[DISCOUNT_PRICE_KEY],
      originalPrice: map[ORIGINAL_PRICE_KEY],
      rating: map[RATING_KEY] ?? 0.0,
      highlights: map[HIGHLIGHTS_KEY],
      description: map[DESCRIPTION_KEY],
      seller: map[SELLER_KEY],
      owner: map[OWNER_KEY],
      quantity: map[Quantity] ?? 0,
      searchTags: (map[SEARCH_TAGS_KEY] as List?)?.cast<String>(),
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      IMAGES_KEY: images,
      TITLE_KEY: title,
      VARIANT_KEY: variant,
      PRODUCT_TYPE_KEY: EnumToString.convertToString(productType),
      DISCOUNT_PRICE_KEY: discountPrice,
      ORIGINAL_PRICE_KEY: originalPrice,
      RATING_KEY: rating,
      HIGHLIGHTS_KEY: highlights,
      DESCRIPTION_KEY: description,
      SELLER_KEY: seller,
      OWNER_KEY: owner,
      SEARCH_TAGS_KEY: searchTags,
      Quantity: quantity,
    };

    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (images != null) map[IMAGES_KEY] = images;
    if (title != null) map[TITLE_KEY] = title;
    if (variant != null) map[VARIANT_KEY] = variant;
    if (discountPrice != null) map[DISCOUNT_PRICE_KEY] = discountPrice;
    if (originalPrice != null) map[ORIGINAL_PRICE_KEY] = originalPrice;
    map[RATING_KEY] = rating;
    if (highlights != null) map[HIGHLIGHTS_KEY] = highlights;
    if (description != null) map[DESCRIPTION_KEY] = description;
    if (seller != null) map[SELLER_KEY] = seller;
    if (productType != null) map[PRODUCT_TYPE_KEY] = EnumToString.convertToString(productType);
    if (owner != null) map[OWNER_KEY] = owner;
    if (searchTags != null) map[SEARCH_TAGS_KEY] = searchTags;
    if (quantity != null) map[Quantity] = quantity;

    return map;
  }
}




List<Product> createDemoData() {
  List<Product> demoData = [];

  // Product 1
  Product product1 = Product(
    "1",
    images: ["https://picsum.photos/seed/picsum/200/300", "https://picsum.photos/seed/picsum/200/300"],
    title: "Product 1",
    variant: "Red",
    productType: ProductType.Electronics,
    discountPrice: 500,
    originalPrice: 1000,
    rating: 4.5,
    highlights: "Some highlights for Product 1",
    description: "Description for Product 1",
    seller: "Seller 1",
    owner: "Owner 1",
    searchTags: ["Product", "Red", "Electronics"],
  );
  demoData.add(product1);

  // Product 2
  Product product2 = Product(
    "2",
    images: ["https://picsum.photos/seed/picsum/200/300", "https://picsum.photos/seed/picsum/200/300"],
    title: "Product 2",
    variant: "Blue",
    productType: ProductType.Books,
    discountPrice: 300,
    originalPrice: 600,
    rating: 4.2,
    highlights: "Some highlights for Product 2",
    description: "Description for Product 2",
    seller: "Seller 2",
    owner: "Owner 2",
    searchTags: ["Product", "Blue", "Books"],
  );
  demoData.add(product2);
// Continue adding more products...
// Product 3
  Product product3 = Product(
    "3",
    images: ["https://picsum.photos/seed/picsum/200/300", "https://picsum.photos/seed/picsum/200/300"],
    title: "Product 3",
    variant: "Green",
    productType: ProductType.Fashion,
    discountPrice: 250,
    originalPrice: 450,
    rating: 4.0,
    highlights: "Some highlights for Product 3",
    description: "Description for Product 3",
    seller: "Seller 3",
    owner: "Owner 3",
    searchTags: ["Product", "Green", "Fashion"],
  );
  demoData.add(product3);

// Product 4
  Product product4 = Product(
    "4",
    images: ["https://picsum.photos/seed/picsum/200/300", "https://picsum.photos/seed/picsum/200/300"],
    title: "Product 4",
    variant: "Large",
    productType: ProductType.Groceries,
    discountPrice: 50,
    originalPrice: 100,
    rating: 4.8,
    highlights: "Some highlights for Product 4",
    description: "Description for Product 4",
    seller: "Seller 4",
    owner: "Owner 4",
    searchTags: ["Product", "Large", "Groceries"],
  );
  demoData.add(product4);

// Continue adding more products...
// Product 5
  Product product5 = Product(
    "5",
    images: ["https://picsum.photos/seed/picsum/200/300", "https://picsum.photos/seed/picsum/200/300"],
    title: "Product 5",
    variant: "Black",
    productType: ProductType.Art,
    discountPrice: 150,
    originalPrice: 300,
    rating: 4.6,
    highlights: "Some highlights for Product 5",
    description: "Description for Product 5",
    seller: "Seller 5",
    owner: "Owner 5",
    searchTags: ["Product", "Black", "Art"],
  );
  demoData.add(product5);

// Continue adding more products...
// Product 6
  Product product6 = Product(
    "6",
    images: ["https://picsum.photos/seed/picsum/200/300", "https://picsum.photos/seed/picsum/200/300"],
    title: "Product 6",
    variant: "White",
    productType: ProductType.Electronics,
    discountPrice: 750,
    originalPrice: 1200,
    rating: 4.2,
    highlights: "Some highlights for Product 6",
    description: "Description for Product 6",
    seller: "Seller 6",
    owner: "Owner 6",
    searchTags: ["Product", "White", "Electronics"],
  );
  demoData.add(product6);

// Continue adding more products...
// Product 7
  Product product7 = Product(
    "7",
    images: ["https://picsum.photos/seed/picsum/200/300", "https://picsum.photos/seed/picsum/200/300"],
    title: "Product 7",
    variant: "XL",
    productType: ProductType.Fashion,
    discountPrice: 300,
    originalPrice: 500,
    rating: 4.7,
    highlights: "Some highlights for Product 7",
    description: "Description for Product 7",
    seller: "Seller 7",
    owner: "Owner 7",
    searchTags: ["Product", "XL", "Fashion"],
  );
  demoData.add(product7);

// Continue adding more products...
// Product 8
  Product product8 = Product(
    "8",
    images: ["https://picsum.photos/seed/picsum/200/300", "https://picsum.photos/seed/picsum/200/300"],
    title: "Product 8",
    variant: "Small",
    productType: ProductType.Books,
    discountPrice: 100,
    originalPrice: 200,
    rating: 4.4,
    highlights: "Some highlights for Product 8",
    description: "Description for Product 8",
    seller: "Seller 8",
    owner: "Owner 8",
    searchTags: ["Product", "Small", "Books"],
  );
  demoData.add(product8);

// Continue adding more products...
// Product 9
  Product product9 = Product(
    "9",
    images: ["https://picsum.photos/seed/picsum/200/300", "https://picsum.photos/seed/picsum/200/300"],
    title: "Product 9",
    variant: "Blue",
    productType: ProductType.Groceries,
    discountPrice: 30,
    originalPrice: 50,
    rating: 4.9,
    highlights: "Some highlights for Product 9",
    description: "Description for Product 9",
    seller: "Seller 9",
    owner: "Owner 9",
    searchTags: ["Product", "Blue", "Groceries"],
  );
  demoData.add(product9);

// Continue adding more products...
// Product 10
  Product product10 = Product(
    "10",
    images: ["https://picsum.photos/seed/picsum/200/300", "https://picsum.photos/seed/picsum/200/300"],
    title: "Product 10",
    variant: "Black",
    productType: ProductType.Art,
    discountPrice: 200,
    originalPrice: 350,
    rating: 4.1,
    highlights: "Some highlights for Product 10",
    description: "Description for Product 10",
    seller: "Seller 10",
    owner: "Owner 10",
    searchTags: ["Product", "Black", "Art"],
  );
  demoData.add(product10);

// Continue adding more products...
// Product 11
  Product product11 = Product(
    "11",
    images: ["https://picsum.photos/seed/picsum/200/300", "https://picsum.photos/seed/picsum/200/300"],
    title: "Product 11",
    variant: "Red",
    productType: ProductType.Electronics,
    discountPrice: 600,
    originalPrice: 1100,
    rating: 4.8,
    highlights: "Some highlights for Product 11",
    description: "Description for Product 11",
    seller: "Seller 11",
    owner: "Owner 11",
    searchTags: ["Product", "Red", "Electronics"],
  );
  demoData.add(product11);

// Continue adding more products...
// Product 12
  Product product12 = Product(
    "12",
    images: ["https://picsum.photos/seed/picsum/200/300", "https://picsum.photos/seed/picsum/200/300"],
    title: "Product 12",
    variant: "Blue",
    productType: ProductType.Books,
    discountPrice: 400,
    originalPrice: 800,
    rating: 4.3,
    highlights: "Some highlights for Product 12",
    description: "Description for Product 12",
    seller: "Seller 12",
    owner: "Owner 12",
    searchTags: ["Product", "Blue", "Books"],
  );
  demoData.add(product12);

  // Add more products as needed...

  return demoData;
}

void uploadDemoDataToFirestore(List<Product> demoData) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  for (var product in demoData) {
    try {
      await firestore.collection('products').doc(product.id).set(product.toMap());
      print("Product with ID ${product.id} uploaded successfully.");
    } catch (e) {
      print("Error uploading product with ID ${product.id}: $e");
    }
  }
}

// void main() {
//   List<Product> demoData = createDemoData();
//   uploadDemoDataToFirestore(demoData);
// }