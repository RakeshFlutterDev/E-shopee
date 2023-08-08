import 'package:e_shopee/helper/size_config.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';


class DefaultButton extends StatelessWidget {
  final String? text;
  final Function? press;
  final Color color;
  final bool isLoading;
  final String? loaderText;
  final double? width;
  final bool transparent;
  final double? height;
  final EdgeInsets? margin;
  final Color? textColor;
  final double? fontSize;

  const DefaultButton({
    Key? key, this.text, this.press, this.color = kPrimaryColor, this.isLoading = false, this.loaderText, this.width, this.transparent = false, this.height, this.margin, this.textColor, this.fontSize
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: press == null ? Theme.of(context).disabledColor : transparent
          ? Colors.transparent : color,
      minimumSize: Size(width != null ? width! : Dimensions.webMaxWidth, height != null ? height! : 50),
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
    return Center(
      child: SizedBox(
        width: width ?? Dimensions.webMaxWidth,
        child: Padding(
          padding: margin == null ? const EdgeInsets.all(0) : margin!,
          child: TextButton(
            style: flatButtonStyle,
            onPressed: isLoading ? null : press as void Function()?,
            child: isLoading ? Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 15, width: 15,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2,
                ),
              ),
              SizedBox(width: Dimensions.paddingSizeSmall),

              Text(loaderText!, style: josefinMedium.copyWith(color: textColor ?? (transparent ? kPrimaryColor : Colors.white))),
            ]),
            ) : Text(text!, textAlign: TextAlign.center, style: josefinMedium.copyWith(
              color: textColor ?? (transparent ? kPrimaryColor : Colors.white),
              fontSize: fontSize ?? Dimensions.fontSizeLarge,
            )),
          ),
        ),
      ),
    );
  }
}
