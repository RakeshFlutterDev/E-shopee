class Dimensions {
  static Dimensions _instance = Dimensions._();
  double _width = 1300; // Default width, you can change it as per your requirement

  Dimensions._(); // Private constructor

  static Dimensions getInstance() {
    return _instance;
  }

  void setWidth(double width) {
    _width = width;
  }

  static double get fontSizeExtraExtraSmall => getInstance()._width >= 1300 ? 9 : 6;
  static double get fontSizeExtraSmall => getInstance()._width >= 1300 ? 14 : 10;
  static double get fontSizeSmall => getInstance()._width >= 1300 ? 16 : 12;
  static double get fontSizeDefault => getInstance()._width >= 1300 ? 18 : 14;
  static double get fontSizeLarge => getInstance()._width >= 1300 ? 20 : 16;
  static double get fontSizeExtraLarge => getInstance()._width >= 1300 ? 22 : 18;
  static double get fontSizeOverLarge => getInstance()._width >= 1300 ? 28 : 24;

  static double get paddingSizeExtraSmall => 5.0;
  static double get paddingSizeSmall => 10.0;
  static double get paddingSizeDefault => 15.0;
  static double get paddingSizeLarge => 20.0;
  static double get paddingSizeExtraLarge => 25.0;
  static double get paddingSizeOverLarge => 30.0;

  static double get radiusSmall => 5.0;
  static double get radiusDefault => 10.0;
  static double get radiusLarge => 15.0;
  static double get radiusExtraLarge => 20.0;

  static const double webMaxWidth = 1170;
  static double get width => getInstance()._width;
}
