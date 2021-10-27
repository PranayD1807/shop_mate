import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_mate/providers/products.dart';

class ProductDetailsScreen extends StatelessWidget {
  // final String title;

  static const routeName = './product_detail';
  // ProductDetailsScreen(this.title);
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
    // listen = false because we don't need to rebuild this widget

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              // titlePadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              centerTitle: true,
              title: Text(
                loadedProduct.title,
              ),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Text(
                'Price:  \$${loadedProduct.price}',
                style: TextStyle(color: Colors.pink, fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Description:  ' + loadedProduct.description,
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
              ),
              SizedBox(
                height: 1000,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
