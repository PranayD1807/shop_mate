import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  // final String title;

  static const routeName = './product_detail';
  // ProductDetailsScreen(this.title);
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
    );
  }
}
