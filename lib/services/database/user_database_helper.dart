import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shopee/components/custom_snackbar.dart';
import 'package:e_shopee/models/address_model.dart';
import 'package:e_shopee/models/cart_item_model.dart';
import 'package:e_shopee/models/ordered_product_model.dart';
import 'package:e_shopee/services/auth/auth_service.dart';
import 'package:e_shopee/services/database/product_database_helper.dart';
import 'package:e_shopee/utils/html_type.dart';

class UserDatabaseHelper {

  static const String USERS_COLLECTION_NAME = "users";
  static const String ADDRESSES_COLLECTION_NAME = "addresses";
  static const String CART_COLLECTION_NAME = "cart";
  static const String ORDERED_PRODUCTS_COLLECTION_NAME = "ordered_products";
  static const String ITEM_COUNT_KEY = "item_count";
  static const String PHONE_KEY = 'phone';
  static const String FIRST_NAME_KEY = 'fName';
  static const String LAST_NAME_KEY = 'lName';
  static const String EMAIL_KEY = 'email';
  static const String DP_KEY = "display_picture";
  static const String FAV_PRODUCTS_KEY = "favourite_products";
  static const String ORIGINAL_PRICE = "originalPrice";
  static const String SUBTOTAL = "subtotal";
  static const String TAX = "tax";
  static const String DELIVERY_CHARGE = "deliveryCharge";
  static const String QUANTITY = "quantity";
  static const String TOTAL = "total";


  UserDatabaseHelper._privateConstructor();
  static UserDatabaseHelper _instance = UserDatabaseHelper._privateConstructor();
  factory UserDatabaseHelper() => _instance;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> createNewUser(String uid, String email, String fName,String lName, String phoneNumber) async {
    await _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid).set({
      DP_KEY: null,
      PHONE_KEY: phoneNumber,
      FAV_PRODUCTS_KEY: <String>[],
      FIRST_NAME_KEY: fName,
      LAST_NAME_KEY:lName,
      EMAIL_KEY:email,
    });
    await AuthService().updateCurrentUserDisplayName(fName,lName);
  }

  Future<void> deleteCurrentUserData() async {
    final uid = AuthService().currentUser.uid;
    final docRef = _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid);
    final cartCollectionRef = docRef.collection(CART_COLLECTION_NAME);
    final addressCollectionRef = docRef.collection(ADDRESSES_COLLECTION_NAME);
    final ordersCollectionRef =
    docRef.collection(ORDERED_PRODUCTS_COLLECTION_NAME);

    final cartDocs = await cartCollectionRef.get();
    for (final cartDoc in cartDocs.docs) {
      await cartCollectionRef.doc(cartDoc.id).delete();
    }
    final addressesDocs = await addressCollectionRef.get();
    for (final addressDoc in addressesDocs.docs) {
      await addressCollectionRef.doc(addressDoc.id).delete();
    }
    final ordersDoc = await ordersCollectionRef.get();
    for (final orderDoc in ordersDoc.docs) {
      await ordersCollectionRef.doc(orderDoc.id).delete();
    }

    await docRef.delete();
  }

  Future<bool> isProductFavourite(String productId) async {
    String uid = AuthService().currentUser.uid;
    final userDocSnapshot =
    _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid);
    final userDocData = (await userDocSnapshot.get()).data();
    final favList = (userDocData?[FAV_PRODUCTS_KEY] as List?)?.cast<String>() ?? [];
    return favList.contains(productId);
  }

  Future<List<String>> get usersFavouriteProductsList async {
    String uid = AuthService().currentUser.uid;
    final userDocSnapshot =
    _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid);
    final userDocData = (await userDocSnapshot.get()).data();
    final favList = userDocData?[FAV_PRODUCTS_KEY] as List?;
    return favList?.cast<String>() ?? [];
  }

  Future<bool> switchProductFavouriteStatus(
      String productId, bool newState) async {
    String uid = AuthService().currentUser.uid;
    final userDocSnapshot =
    _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid);

    if (newState == true) {
      userDocSnapshot.update({
        FAV_PRODUCTS_KEY: FieldValue.arrayUnion([productId])
      });
    } else {
      userDocSnapshot.update({
        FAV_PRODUCTS_KEY: FieldValue.arrayRemove([productId])
      });
    }
    return true;
  }

  Future<List<String>> get addressesList async {
    String uid = AuthService().currentUser.uid;
    final snapshot = await _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(ADDRESSES_COLLECTION_NAME).get();
    final addresses = <String>[];
    snapshot.docs.forEach((doc) {
      addresses.add(doc.id);
    });
    return addresses;
  }

  Future<Address> getAddressFromId(String id) async {
    String uid = AuthService().currentUser.uid;
    final doc = await _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(ADDRESSES_COLLECTION_NAME).doc(id).get();
    final address = Address.fromMap(doc.data()!, id:doc.id);
    return address;
  }

  Future<bool> addAddressForCurrentUser(Address address) async {
    String uid = AuthService().currentUser.uid;
    final addressesCollectionReference = _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(ADDRESSES_COLLECTION_NAME);
    await addressesCollectionReference.add(address.toMap());
    return true;
  }

  Future<bool> deleteAddressForCurrentUser(String id) async {
    String uid = AuthService().currentUser.uid;
    final addressDocReference = _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(ADDRESSES_COLLECTION_NAME).doc(id);
    await addressDocReference.delete();
    return true;
  }

  Future<bool> updateAddressForCurrentUser(Address address) async {
    String uid = AuthService().currentUser.uid;
    final addressDocReference = _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(ADDRESSES_COLLECTION_NAME).doc(address.id);
    await addressDocReference.update(address.toMap());
    return true;
  }

  Future<CartItem> getCartItemFromId(String id) async {
    String uid = AuthService().currentUser.uid;
    final cartCollectionRef = _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(id);
    final docSnapshot = await docRef.get();
    final cartItem = CartItem.fromMap(docSnapshot.data()!, id: docSnapshot.id);
    return cartItem;
  }

  Future<bool> addProductToCart(String productId) async {
    String uid = AuthService().currentUser.uid;
    final cartCollectionRef = FirebaseFirestore.instance
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(productId);
    final docSnapshot = await docRef.get();
    bool alreadyPresent = docSnapshot.exists;
    if (alreadyPresent == false) {
      await docRef.set(CartItem(itemCount: 1).toMap());
    } else {
      await docRef.update({ITEM_COUNT_KEY: FieldValue.increment(1)});
    }
    return true;
  }


  Future<List<String>> emptyCart() async {
    String uid = AuthService().currentUser.uid;
    final cartItems = await _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(CART_COLLECTION_NAME).get();
    final orderedProductsUid = <String>[];
    for (final doc in cartItems.docs) {
      orderedProductsUid.add(doc.id);
      await doc.reference.delete();
    }
    return orderedProductsUid;
  }

  Future<num> get cartTotal async {
    String uid = AuthService().currentUser.uid;
    final cartItems = await _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(CART_COLLECTION_NAME).get();
    num total = 0.0;
    for (final doc in cartItems.docs) {
      num itemsCount = doc.data()[CartItem.ITEM_COUNT_KEY];
      final product = await ProductDatabaseHelper().getProductWithID(doc.id);
      total += (itemsCount * product!.discountPrice!);
    }
    return total;
  }

  Future<Map<String, num>> getOrderSummary() async {
    String uid = AuthService().currentUser.uid;
    final cartItems = await _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(CART_COLLECTION_NAME).get();

    num subtotal = 0.0;
    num originalPrice = 0.0;
    num quantity = 0;

    for (final doc in cartItems.docs) {
      num itemsCount = doc.data()[CartItem.ITEM_COUNT_KEY];
      final product = await ProductDatabaseHelper().getProductWithID(doc.id);
      subtotal += (itemsCount * product!.discountPrice!);
      originalPrice += (itemsCount * product.originalPrice!);
      quantity += itemsCount;
    }

    num taxPercentage = 0.05;
    num deliveryCharge = 40;

    num tax = subtotal * taxPercentage;
    num total = subtotal + tax + deliveryCharge;

    return {
      ORIGINAL_PRICE: originalPrice,
      SUBTOTAL: subtotal,
      TAX: tax,
      DELIVERY_CHARGE: deliveryCharge,
      TOTAL: total,
      QUANTITY: quantity,
    };
  }

  Future<bool> removeProductFromCart(context ,String cartItemID) async {
    String uid = AuthService().currentUser.uid;
    final cartCollectionReference = _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(CART_COLLECTION_NAME);
    await cartCollectionReference.doc(cartItemID).delete();
    showCustomSnackBar(context, 'Item removed from cart',isError: false);
    return true;
  }

  Future<bool> increaseCartItemCount(String cartItemID) async {
    String uid = AuthService().currentUser.uid;
    final cartCollectionRef = _firebaseFirestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(cartItemID);
    docRef.update({CartItem.ITEM_COUNT_KEY: FieldValue.increment(1)});
    return true;
  }

  Future<bool> decreaseCartItemCount(context, String cartItemID) async {
    String uid = AuthService().currentUser.uid;
    final cartCollectionRef = _firebaseFirestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .collection(CART_COLLECTION_NAME);
    final docRef = cartCollectionRef.doc(cartItemID);
    final docSnapshot = await docRef.get();
    int currentCount = docSnapshot.data()![CartItem.ITEM_COUNT_KEY];
    if (currentCount <= 1) {
      return removeProductFromCart(context, cartItemID);
    } else {
      docRef.update({CartItem.ITEM_COUNT_KEY: FieldValue.increment(-1)});
    }
    return true;
  }

  Future<List<String>> get allCartItemsList async {
    String uid = AuthService().currentUser.uid;
    final querySnapshot = await _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(CART_COLLECTION_NAME).get();
    final itemsId = <String>[];
    for (final item in querySnapshot.docs) {
      itemsId.add(item.id);
    }
    return itemsId;
  }

  Future<List<String>> get orderedProductsList async {
    String uid = AuthService().currentUser.uid;
    final orderedProductsSnapshot = await _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(ORDERED_PRODUCTS_COLLECTION_NAME).get();
    final orderedProductsId = <String>[];
    for (final doc in orderedProductsSnapshot.docs) {
      orderedProductsId.add(doc.id);
    }
    return orderedProductsId;
  }

  Future<bool> addToMyOrders(List<OrderedProduct> orders, String orderId) async {
    String uid = AuthService().currentUser.uid;
    final orderedProductsCollectionRef = _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(ORDERED_PRODUCTS_COLLECTION_NAME);
    for (final order in orders) {
      await orderedProductsCollectionRef.add({
        ...order.toMap(),
        'order_id': orderId,
      });
    }
    return true;
  }

  Future<String> generateOrderId() async {
    String uid = AuthService().currentUser.uid;
    final userDoc = await _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid).get();
    int currentOrderCount = userDoc.data()?['order_count'] ?? 0;
    int newOrderCount = currentOrderCount + 1;
    await userDoc.reference.update({'order_count': newOrderCount});
    String baseOrderId = "10000";
    String orderId = (int.parse(baseOrderId) + newOrderCount).toString();
    return orderId;
  }

  Future<OrderedProduct> getOrderedProductFromId(String id) async {
    String uid = AuthService().currentUser.uid;
    final doc = await _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid).collection(ORDERED_PRODUCTS_COLLECTION_NAME).doc(id).get();
    final orderedProduct = OrderedProduct.fromMap(doc.data()!, id: doc.id);
    return orderedProduct;
  }

  Stream<DocumentSnapshot> get currentUserDataStream {
    String uid = AuthService().currentUser.uid;
    return _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid).get().asStream();
  }

  Future<bool> updatePhoneForCurrentUser(String phone) async {
    String uid = AuthService().currentUser.uid;
    final userDocSnapshot = _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update({PHONE_KEY: phone});
    return true;
  }

  String getPathForCurrentUserDisplayPicture() {
    final String currentUserUid = AuthService().currentUser.uid;
    return "user/display_picture/$currentUserUid";
  }

  Future<bool> uploadDisplayPictureForCurrentUser(String url) async {
    String uid = AuthService().currentUser.uid;
    final userDocSnapshot = _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update({DP_KEY: url});
    return true;
  }

  Future<bool> removeDisplayPictureForCurrentUser() async {
    String uid = AuthService().currentUser.uid;
    final userDocSnapshot = _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid);
    await userDocSnapshot.update({DP_KEY: FieldValue.delete()});
    return true;
  }

  Future<String> get displayPictureForCurrentUser async {
    String uid = AuthService().currentUser.uid;
    final userDocSnapshot = await _firebaseFirestore.collection(USERS_COLLECTION_NAME).doc(uid).get();
    return userDocSnapshot.data()?[DP_KEY] as String;
  }

  Future<String> getUserName(String uid) async {
    final userDocSnapshot = await _firebaseFirestore
        .collection(USERS_COLLECTION_NAME)
        .doc(uid)
        .get();

    if (userDocSnapshot.exists) {
      final userData = userDocSnapshot.data();
      final firstName = userData?['fName'] ?? "Unknown";
      final lastName = userData?['lName'] ?? "User";
      return '$firstName $lastName';
    } else {
      return "Unknown User";
    }
  }

  Future<String> fetchPolicyContent(HtmlType policyType) async {
    final documentSnapshot = await FirebaseFirestore.instance
        .collection('policies')
        .doc(policyType.toString())
        .get();
    return documentSnapshot.get('content') as String;
  }
}
