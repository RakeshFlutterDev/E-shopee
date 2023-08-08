
import 'package:e_shopee/models/model.dart';

class CartItem extends Model {
  static const String PRODUCT_ID_KEY = "product_id";
  static const String ITEM_COUNT_KEY = "item_count";

  int itemCount;
  CartItem({
    String? id,
    this.itemCount = 0,
  }) : super(id ?? '');

  factory CartItem.fromMap(Map<String, dynamic> map, {required String id}) {
    return CartItem(
      id: id,
      itemCount: map[ITEM_COUNT_KEY] ?? 0,
    );
  }


  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      ITEM_COUNT_KEY: itemCount,
    };
    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    map[ITEM_COUNT_KEY] = itemCount;
    return map;
  }
}