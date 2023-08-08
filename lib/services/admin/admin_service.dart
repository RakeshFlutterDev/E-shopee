import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shopee/models/product_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  List<Product> addProducts = await createData();
  await uploadDataToFirestore(addProducts);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Dummy Data Example')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              List<Product> dummyProducts = await createData();
              // Upload dummy data to Firestore
              await uploadDataToFirestore(dummyProducts);
              print("Dummy data uploaded to Firestore successfully!");
            },
            child: Text('Create Dummy Data'),
          ),
        ),
      ),
    );
  }
}

// Function to load asset image names from the 'assets/images' folder
Future<List<String>> loadAssetImages() async {
  final manifestContent = await rootBundle.loadString('AssetManifest.json');
  final Map<String, dynamic> manifestMap = json.decode(manifestContent);
  return manifestMap.keys
      .where((String key) => key.contains('assets/images/'))
      .toList();
}

Future<List<Product>> createData() async {
  List<String> imagePaths = await loadAssetImages();
  List<Product> dummyProducts = [
    Product(
      "1",
      images: [imagePaths[0], imagePaths[1]], // Use asset image paths
      title: "Watch Product ",
      productType: ProductType.Electronics,
      discountPrice: 20.0,
      originalPrice: 50.0,
      rating: 4.5,
      highlights: "Highlight 1",
      description: "Description of Dummy Product 1",
      seller: "Seller 1",
      owner: "Owner 1",
      searchTags: ["tag1", "tag2", "tag3"],
    ),
    Product(
      "2",
      images: [imagePaths[2], imagePaths[3]], // Use asset image paths
      title: "Gaming Pad",
      productType: ProductType.Fashion,
      discountPrice: 15.0,
      originalPrice: 30.0,
      rating: 4.2,
      highlights: "Highlight 2",
      description: "Description of Dummy Product 2",
      seller: "Seller 2",
      owner: "Owner 2",
      searchTags: ["tag2", "tag4"],
    ),
    // Add more dummy products here...
  ];
  return dummyProducts;
}

Future<void> uploadDataToFirestore(List<Product> products) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference productsCollection = firestore.collection('products');

  // Loop through the list of dummy products and add them to Firestore
  for (Product product in products) {
    await productsCollection.doc(product.id).set(product.toMap());
  }
}