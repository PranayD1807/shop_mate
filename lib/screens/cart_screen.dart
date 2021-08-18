import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';
import '../providers/cart.dart' show Cart; // only imports cart from this file
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  // const CartScreen({ Key? key }) : super(key: key);
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$ ' + cart.totalAmount.toStringAsFixed(2),
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                    onPressed: () {
                      if (cart.itemCount != 0) {
                        Provider.of<Orders>(context, listen: false).addOrder(
                            cart.items.values.toList(), cart.totalAmount);
                        final snackBar = SnackBar(
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                            backgroundColor: Theme.of(context).accentColor,
                            content: Text(
                              'Order has been placed and will be delivered shortly.',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        cart.clear();
                      } else {
                        final snackBar = SnackBar(
                            behavior: SnackBarBehavior.floating,
                            duration: Duration(seconds: 2),
                            backgroundColor: Theme.of(context).accentColor,
                            content: Text(
                              'No Items Found!',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text('Order Now'),
                    // textColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (ctx, i) => CartItem(
              id: cart.items.values.toList()[i].id,
              price: cart.items.values.toList()[i].price,
              quantity: cart.items.values.toList()[i].quantity,
              title: cart.items.values.toList()[i].title,
              productId: cart.items.keys.toList()[i],
            ),
          ))
        ],
      ),
    );
  }
}
