import 'package:provider/provider.dart';
import 'package:shop_mate/providers/auth.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  // const ProductItem({ Key? key }) : super(key: key);

  // final String id;
  // final String title;
  // final String imageUrl;
  // final double price;

  // ProductItem(this.id, this.title, this.imageUrl, this.price);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        header: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.black54),
          child: Text(
            product.title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailsScreen.routeName,
                arguments: product.id);
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('lib/images/product-placeholder.png'),
              image: NetworkImage(
                product.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black.withOpacity(0.4),
          leading: IconButton(
            color: Colors.pink[400],
            icon: Icon(
                product.isFavourite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              product.toggleFavouriteStatus(authData.token, authData.userId);
            },
          ),
          title: Text(
            "\$" + product.price.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
            // textWidthBasis: TextWidthBasis.longestLine,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
              final snackBar = SnackBar(
                  behavior: SnackBarBehavior.floating,
                  // duration: Duration(milliseconds: 800),
                  action: SnackBarAction(
                    textColor: Colors.white,
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(product.id);
                    },
                  ),
                  backgroundColor: Colors.pink[500],
                  content: Text(
                    product.title + ' added to the cart',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ));
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            color: Colors.pink[400],
          ),
        ),
      ),
    );
  }
}
