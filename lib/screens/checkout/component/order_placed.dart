import 'package:e_shopee/screens/dashboard/dashboard_screen.dart';
import 'package:e_shopee/utils/dimensions.dart';
import 'package:e_shopee/utils/styles.dart';
import 'package:flutter/material.dart';

class OrderPlacedWidget extends StatefulWidget {
  const OrderPlacedWidget({super.key});

  @override
  State<OrderPlacedWidget> createState() => _OrderPlacedWidgetState();
}

class _OrderPlacedWidgetState extends State<OrderPlacedWidget>
    with TickerProviderStateMixin {
  late AnimationController scaleController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
  late Animation<double> scaleAnimation = CurvedAnimation(parent: scaleController, curve: Curves.elasticOut);
  late AnimationController checkController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
  late Animation<double> checkAnimation = CurvedAnimation(parent: checkController, curve: Curves.linear);

  @override
  void initState() {
    super.initState();
    scaleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        checkController.forward();
      }
    });
    scaleController.forward();

  }

  @override
  void dispose() {
    scaleController.dispose();
    checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double circleSize = 100;
    double iconSize = 85;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Center(
                  child: ScaleTransition(
                    scale: scaleAnimation,
                    child: Container(
                      height: circleSize,
                      width: circleSize,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                SizeTransition(
                  sizeFactor: checkAnimation,
                  axis: Axis.horizontal,
                  axisAlignment: -1,
                  child: Center(
                    child: Icon(Icons.check, color: Colors.white, size: iconSize),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            Text(
              'Order Placed Successfully!',
              style: josefinBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
            ),
            const SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: (context)=>DashboardScreen(pageIndex: 0)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade900,
              ),
              child: Text('Back to Home', style: josefinRegular),
            ),
          ],
        ),
      ),
    );
  }
}
