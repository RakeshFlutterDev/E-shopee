import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shopee/models/product_model.dart';
import 'package:e_shopee/models/review_model.dart';
import 'package:e_shopee/services/auth/auth_service.dart';
import 'package:enum_to_string/enum_to_string.dart';

class ProductDatabaseHelper {
  static const String PRODUCTS_COLLECTION_NAME = "products";
  static const String REVIEWS_COLLECTION_NAME = "reviews";

  ProductDatabaseHelper._privateConstructor();

  static ProductDatabaseHelper _instance =
  ProductDatabaseHelper._privateConstructor();

  factory ProductDatabaseHelper() {
    return _instance;
  }

  late FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  FirebaseFirestore get firestore => _firebaseFirestore;

  Future<List<String>> searchInProducts(String query,
      {ProductType? productType}) async {
    Query queryRef;
    if (productType == null) {
      queryRef = firestore.collection(PRODUCTS_COLLECTION_NAME);
    } else {
      final productTypeStr = EnumToString.convertToString(productType);
      print(productTypeStr);
      queryRef = firestore.collection(PRODUCTS_COLLECTION_NAME).where(Product.PRODUCT_TYPE_KEY, isEqualTo: productTypeStr);
    }

    Set<String> productsId = Set<String>();
    final querySearchInTags =
    await queryRef.where(Product.SEARCH_TAGS_KEY, arrayContains: query).get();
    for (final doc in querySearchInTags.docs) {
      productsId.add(doc.id);
    }
    final queryRefDocs = await queryRef.get();
    for (final doc in queryRefDocs.docs) {
      final productData = doc.data();
      if (productData != null) {
        final product = Product.fromMap(productData as Map<String, dynamic>, id: doc.id);
        if (product.title.toString().toLowerCase().contains(query) ||
            product.description.toString().toLowerCase().contains(query) ||
            product.highlights.toString().toLowerCase().contains(query) ||
            product.variant.toString().toLowerCase().contains(query) ||
            product.seller.toString().toLowerCase().contains(query)) {
          productsId.add(product.id);
        }
      }
    }
    return productsId.toList();
  }

  Future<bool> addProductReview(String productId, Review review) async {
    final reviewesCollectionRef = firestore
        .collection(PRODUCTS_COLLECTION_NAME)
        .doc(productId)
        .collection(REVIEWS_COLLECTION_NAME);
    final reviewDoc = reviewesCollectionRef.doc(review.reviewerUid);
    if ((await reviewDoc.get()).exists == false) {
      reviewDoc.set(review.toMap());
      return await addUsersRatingForProduct(
        productId,
        review.rating!,
      );
    } else {
      int oldRating = (await reviewDoc.get()).data()?['rating'] ?? 0;
      reviewDoc.update(review.toUpdateMap());
      return await addUsersRatingForProduct(productId, review.rating!,
          oldRating: oldRating);
    }
  }


  Future<bool> addUsersRatingForProduct(String productId, int rating,
      {int? oldRating}) async {
    final productDocRef =
        firestore.collection(PRODUCTS_COLLECTION_NAME).doc(productId);
    final ratingsCount =
        (await productDocRef.collection(REVIEWS_COLLECTION_NAME).get()).docs.length;
    final productDoc = await productDocRef.get();
    final prevRating = productDoc.data()![Review.RATING_KEY];
    double newRating;
    if (oldRating == null) {
      newRating = (prevRating * (ratingsCount - 1) + rating) / ratingsCount;
    } else {
      newRating =
          (prevRating * (ratingsCount) + rating - oldRating) / ratingsCount;
    }
    final newRatingRounded = double.parse(newRating.toStringAsFixed(1));
    await productDocRef.update({Product.RATING_KEY: newRatingRounded});
    return true;
  }

  Future<Review?> getProductReviewWithID(
      String productId, String reviewId) async {
    final reviewesCollectionRef = firestore
        .collection(PRODUCTS_COLLECTION_NAME)
        .doc(productId)
        .collection(REVIEWS_COLLECTION_NAME);
    final reviewDoc = await reviewesCollectionRef.doc(reviewId).get();
    if (reviewDoc.exists) {
      return Review.fromMap(reviewDoc.data()!, id: reviewDoc.id);
    }
    return null;
  }

  Stream<List<Review>> getAllReviewsStreamForProductId(String productId) async* {
    final reviewesQuerySnapshot = await firestore
        .collection(PRODUCTS_COLLECTION_NAME)
        .doc(productId)
        .collection(REVIEWS_COLLECTION_NAME)
        .get();
    List<Review> reviews = [];
    for (final reviewDoc in reviewesQuerySnapshot.docs) {
      Review review = Review.fromMap(reviewDoc.data(), id: reviewDoc.id);
      reviews.add(review);
    }
    yield reviews;
  }


  Future<Product?> getProductWithID(String productId) async {
    //print('ProductDatabaseHelper - Getting product with ID: $productId');
    final docSnapshot =
    await firestore.collection(PRODUCTS_COLLECTION_NAME).doc(productId).get();

    if (docSnapshot.exists) {
      final productData = docSnapshot.data();
      if (productData != null) {
        final product = Product.fromMap(productData, id: docSnapshot.id);
      //  print('Product Quantity: ${product.quantity}');
        return product;
      }
    }
    return null;
  }



  Future<String> addUsersProduct(Product product) async {
    String uid = AuthService().currentUser.uid;
    final productMap = product.toMap();
    product.owner = uid;

    final productTypeKey = Product.PRODUCT_TYPE_KEY;
    if (productMap.containsKey(productTypeKey)) {
      final productType = productMap[productTypeKey];
      if (productType != null) {
        final productTypeStr = EnumToString.convertToString(productType);
        productMap[productTypeKey] = productTypeStr;
      } else {
        productMap[productTypeKey] = ''; // Set a default value or handle the null case as needed
      }
    }

    final productsCollectionReference =
    firestore.collection(PRODUCTS_COLLECTION_NAME);
    final docRef = await productsCollectionReference.add(productMap);
    await docRef.update({
      Product.SEARCH_TAGS_KEY: FieldValue.arrayUnion(
          [productMap[Product.PRODUCT_TYPE_KEY].toString().toLowerCase()])
    });
    return docRef.id;
  }


  Future<bool> deleteUserProduct(String productId) async {
    final productsCollectionReference =
        firestore.collection(PRODUCTS_COLLECTION_NAME);
    await productsCollectionReference.doc(productId).delete();
    return true;
  }

  Future<String> updateUsersProduct(Product product) async {
    final productMap = product.toUpdateMap();
    final productsCollectionReference =
        firestore.collection(PRODUCTS_COLLECTION_NAME);
    final docRef = productsCollectionReference.doc(product.id);
    await docRef.update(productMap);
    if (product.productType != null) {
      await docRef.update({
        Product.SEARCH_TAGS_KEY: FieldValue.arrayUnion(
            [productMap[Product.PRODUCT_TYPE_KEY].toString().toLowerCase()])
      });
    }
    return docRef.id;
  }

  Future<List<String>> getCategoryProductsList(ProductType productType) async {
    final productsCollectionReference =
    firestore.collection(PRODUCTS_COLLECTION_NAME);
    final queryResult = await productsCollectionReference
        .where(Product.PRODUCT_TYPE_KEY,
        isEqualTo: EnumToString.convertToString(productType))
        .get();
    List<String> productsId = [];
    for (final product in queryResult.docs) {
      final id = product.id;
      productsId.add(id);
    }
    return productsId;
  }


  Future<List<String>> get usersProductsList async {
    String uid = AuthService().currentUser.uid;
    final productsCollectionReference =
    firestore.collection(PRODUCTS_COLLECTION_NAME);
    final querySnapshot =
    await productsCollectionReference.where(Product.OWNER_KEY, isEqualTo: uid).get();
    List<String> usersProducts = [];
    querySnapshot.docs.forEach((doc) {
      usersProducts.add(doc.id);
    });
    return usersProducts;
  }


  Future<List<String>> get allProductsList async {
    final products = await firestore.collection(PRODUCTS_COLLECTION_NAME).get();
    List<String> productsId = [];
    for (final product in products.docs) {
      final id = product.id;
      productsId.add(id);
    }
    return productsId;
  }


  Future<bool> updateProductsImages(
      String productId, List<String> imgUrl) async {
    final Product updateProduct = Product(null, images: imgUrl);
    final docRef =
        firestore.collection(PRODUCTS_COLLECTION_NAME).doc(productId);
    await docRef.update(updateProduct.toUpdateMap());
    return true;
  }

  String getPathForProductImage(String id, int index) {
    String path = "products/images/$id";
    return path + "_$index";
  }

  Future<bool> hasUserReviewedProduct(String productId, String reviewerUid) async {
    final reviewCollectionRef = _firebaseFirestore
        .collection(PRODUCTS_COLLECTION_NAME)
        .doc(productId)
        .collection(REVIEWS_COLLECTION_NAME);

    final userReviewDoc = await reviewCollectionRef.doc(reviewerUid).get();

    return userReviewDoc.exists;
  }

}
