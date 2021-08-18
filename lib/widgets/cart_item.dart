import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  //  const CartItem({ Key? key }) : super(key: key);
  final String id;
  final double price;
  final String productId;
  final int quantity;
  final String title;
  CartItem({this.id, this.price, this.quantity, this.title, this.productId});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Colors.pink[100],
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      confirmDismiss: (direction) {
        // return Future.value(true);
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are you sure? '),
                  content: Text('Do you want to remove the item from the cart'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(true);
                      },
                      child: Text('YES!'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop(false);
                      },
                      child: Text('NO!'),
                    ),
                  ],
                ));
      },
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FittedBox(
                    child: Text(
                      '\$' + price.toStringAsFixed(2),
                    ),
                  )),
            ),
            title: Text(title),
            subtitle: Text('Total: \$' + (price * quantity).toStringAsFixed(2)),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
