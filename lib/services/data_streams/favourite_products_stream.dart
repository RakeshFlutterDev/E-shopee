
import 'package:e_shopee/services/data_streams/data_stream.dart';
import 'package:e_shopee/services/database/user_database_helper.dart';

class FavouriteProductsStream extends DataStream<List<String>> {
  @override
  void reload() {
    final favProductsFuture = UserDatabaseHelper().usersFavouriteProductsList;
    favProductsFuture.then((favProducts) {
      addData(favProducts.cast<String>());
    }).catchError((e) {
      addError(e);
    });
  }
}
