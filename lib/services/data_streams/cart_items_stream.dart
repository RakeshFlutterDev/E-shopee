import 'package:e_shopee/services/data_streams/data_stream.dart';
import 'package:e_shopee/services/database/user_database_helper.dart';

class CartItemsStream extends DataStream<List<String>> {
  @override
  void reload() {
    final allProductsFuture = UserDatabaseHelper().allCartItemsList;
    allProductsFuture.then((favProducts) {
      addData(favProducts.cast<String>());
    }).catchError((e) {
      addError(e);
    });
  }
}

