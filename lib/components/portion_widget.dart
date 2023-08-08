import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';

class PortionWidget extends StatelessWidget {
  final String icon;
  final String title;
  final bool hideDivider;
  final String route;
  final String? suffix;

  const PortionWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.route,
    this.hideDivider = false,
    this.suffix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Column(children: [
          Row(children: [
            Image.asset(icon, height: 16, width: 16),
            SizedBox(width: Dimensions.paddingSizeSmall),

            Expanded(
                child: Text(title, style: josefinRegular.copyWith(fontSize: Dimensions.fontSizeDefault))),
            suffix != null ? Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error,
                borderRadius:
                BorderRadius.circular(Dimensions.radiusDefault),
              ),
              padding: EdgeInsets.symmetric(
                  vertical: Dimensions.paddingSizeExtraSmall,
                  horizontal: Dimensions.paddingSizeSmall),
              child: Text(suffix!,
                  style: josefinRegular.copyWith(fontSize: Dimensions.fontSizeSmall,color: Theme.of(context).cardColor)),
            ) : const SizedBox(),
          ]),
          hideDivider ? const SizedBox() : const Divider()
        ]),
      ),
    );
  }
}
