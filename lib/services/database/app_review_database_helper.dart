import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shopee/models/app_review_model.dart';
import 'package:e_shopee/services/auth/auth_service.dart';

class AppReviewDatabaseHelper {
  static const String APP_REVIEW_COLLECTION_NAME = "app_reviews";

  AppReviewDatabaseHelper._privateConstructor();
  static AppReviewDatabaseHelper _instance =
  AppReviewDatabaseHelper._privateConstructor();
  factory AppReviewDatabaseHelper() {
    return _instance;
  }

  late FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<bool> editAppReview(AppReview appReview) async {
    final uid = AuthService().currentUser.uid;
    final docRef = _firebaseFirestore.collection(APP_REVIEW_COLLECTION_NAME).doc(uid);
    final docData = await docRef.get();
    if (docData.exists) {
      docRef.update(appReview.toUpdateMap());
    } else {
      docRef.set(appReview.toMap());
    }
    return true;
  }

  Future<AppReview> getAppReviewOfCurrentUser() async {
    final uid = AuthService().currentUser.uid;
    final docRef = _firebaseFirestore.collection(APP_REVIEW_COLLECTION_NAME).doc(uid);
    final docData = await docRef.get();
    if (docData.exists) {
      final appReview = AppReview.fromMap(docData.data()!, id: docData.id);
      return appReview;
    } else {
      final appReview = AppReview(uid, liked: true, feedback: "");
      docRef.set(appReview.toMap());
      return appReview;
    }
  }
}
