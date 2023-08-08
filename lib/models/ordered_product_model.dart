import 'package:e_shopee/models/model.dart';

class OrderedProduct extends Model {
  static const String PRODUCT_UID_KEY = "Product Id";
  static const String ORDER_ID = "Order Id";
  static const String ORDER_DATE_KEY = "Ordered Date";
  static const String PAYMENT_TYPE = "Payment Type";
  static const String QUANTITY = "Quantity";
  static const String SUBTOTAL_KEY = "Subtotal";
  static const String ORIGINAL_PRICE = "Original Price";
  static const String DELIVERY_CHARGE_KEY = "Delivery Charge";
  static const String DISCOUNT_KEY = "Discount";
  static const String TAX_KEY = "Tax";
  static const String TOTAL_KEY = "Total";

  String? productUid;
  String? orderId;
  String? orderDate;
  String? paymentType;
  double? originalPrice;
  double? quantity;
  double? subtotal;
  double? deliveryCharge;
  double? discount;
  double? tax;
  double? total;

  OrderedProduct(
    String id, {
    this.orderId,
    this.productUid,
    this.orderDate,
    this.paymentType,
    this.originalPrice,
    this.quantity,
    this.subtotal,
    this.discount,
    this.deliveryCharge,
    this.tax,
    this.total,
    required,
  }) : super(id);

  factory OrderedProduct.fromMap(Map<String, dynamic> map, {String? id}) {
    return OrderedProduct(
      id!,
      orderId: map[ORDER_ID],
      productUid: map[PRODUCT_UID_KEY],
      orderDate: map[ORDER_DATE_KEY],
      paymentType: map[PAYMENT_TYPE],
      originalPrice: map[ORIGINAL_PRICE],
      quantity: map[QUANTITY],
      subtotal: map[SUBTOTAL_KEY],
      discount: map[DISCOUNT_KEY],
      deliveryCharge: map[DELIVERY_CHARGE_KEY],
      tax: map[TAX_KEY],
      total: map[TOTAL_KEY],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      ORDER_ID: orderId,
      PRODUCT_UID_KEY: productUid,
      ORDER_DATE_KEY: orderDate,
      PAYMENT_TYPE: paymentType,
      QUANTITY: quantity,
      ORIGINAL_PRICE: originalPrice,
      SUBTOTAL_KEY: subtotal,
      DISCOUNT_KEY: discount,
      DELIVERY_CHARGE_KEY: deliveryCharge,
      TAX_KEY: tax,
      TOTAL_KEY: total,
    };
    return map;
  }

  @override
  Map<String, dynamic> toUpdateMap() {
    final map = <String, dynamic>{};
    if (orderId != null) map[ORDER_ID] = orderId;
    if (productUid != null) map[PRODUCT_UID_KEY] = productUid;
    if (orderDate != null) map[ORDER_DATE_KEY] = orderDate;
    if (paymentType != null) map[PAYMENT_TYPE] = paymentType;
    if (originalPrice != null) map[ORIGINAL_PRICE] = originalPrice;
    if (quantity != null) map[QUANTITY] = quantity;
    if (subtotal != null) map[SUBTOTAL_KEY] = subtotal;
    if (deliveryCharge != null) map[DELIVERY_CHARGE_KEY] = deliveryCharge;
    if (tax != null) map[TAX_KEY] = tax;
    if (total != null) map[TOTAL_KEY] = total;
    return map;
  }
}
