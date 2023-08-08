import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shopee/components/custom_app_bar.dart';
import 'package:e_shopee/utils/html_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HtmlScreen extends StatelessWidget {
  final String title;
  final String htmlContent;

  HtmlScreen({required this.title, required this.htmlContent});

  factory HtmlScreen.fromRouteSettings(RouteSettings settings) {
    final args = settings.arguments as Map<String, dynamic>;
    return HtmlScreen(
      title: args['title'],
      htmlContent: args['htmlContent'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: title,isBackButtonExist: true,onBackPressed: ()=>Navigator.pop(context),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Html(data: htmlContent),
          ),
        ),
      ),
    );
  }
}

class PolicyViewerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Policy Viewer'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final documentSnapshot = await FirebaseFirestore.instance
                      .collection('policies')
                      .doc(HtmlType.privacyPolicy.toString())
                      .get();
                  final htmlContent = documentSnapshot.get('content') as String;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HtmlScreen(
                        title: 'Privacy Policy',
                        htmlContent: htmlContent,
                      ),
                    ),
                  );
                },
                child: Text('Privacy Policy'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final documentSnapshot = await FirebaseFirestore.instance
                      .collection('policies')
                      .doc(HtmlType.termsAndCondition.toString())
                      .get();
                  final htmlContent = documentSnapshot.get('content') as String;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HtmlScreen(
                        title: 'Terms and Conditions',
                        htmlContent: htmlContent,
                      ),
                    ),
                  );
                },
                child: Text('Terms and Conditions'),
              ),
              // Add buttons for other policies
            ],
          ),
        ),
      ),
    );
  }
}
