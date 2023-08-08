import 'package:e_shopee/screens/category_products/category_products_screen.dart';
import 'package:e_shopee/utils/constants.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class BannerCard extends StatefulWidget {
  final List<String> bannerImages;
  final List<String> bannerNames;
  final List<Map<String, dynamic>> productCategories;

  BannerCard({
    required this.bannerImages,
    required this.bannerNames,
    required this.productCategories,
  });

  @override
  State<BannerCard> createState() => _BannerCardState();
}

class _BannerCardState extends State<BannerCard> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: widget.bannerImages.length,
          itemBuilder: (context, index, _) {
            return Stack(children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CategoryProductsScreen(
                        productType: widget.productCategories[index]['product_type'],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: AssetImage(widget.bannerImages[index]),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                        kPrimaryColor,
                        BlendMode.hue,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 60,
                left: 16,
                child: Text(
                  widget.bannerNames[index],
                  style: josefinRegular.copyWith(fontSize: Dimensions.fontSizeLarge,color: kPrimaryLightColor),
                ),
              ),
            ]);
          },
          options: CarouselOptions(
            height: 120,
            aspectRatio: 16 / 8,
            viewportFraction: 0.8,
            enableInfiniteScroll: true,
            autoPlay: true,
            enlargeCenterPage: true,
            autoPlayInterval: Duration(seconds: 3),
            autoPlayAnimationDuration: Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
          ),
        ),
        SizedBox(
            height: 16), // Add some space between the Carousel and the names
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.bannerNames.length,
            (index) => Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index == 0 ? kPrimaryColor : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
