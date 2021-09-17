import 'package:flutter/material.dart';
import 'package:shop_mate/screens/edit_products_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  // const UserProductItem({ Key? key }) : super(key: key);
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem({this.imageUrl, this.title, this.id});
  @override
  Widget build(BuildContext context) {
    // final scaffoldCTX = context;
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        // backgroundColor: Colors.pink,
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(EditProductsScreen.routeName, arguments: id);
                }),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (error) {
                  // final snackBar = SnackBar(
                  //     behavior: SnackBarBehavior.floating,
                  //     duration: Duration(seconds: 2),
                  //     backgroundColor: Theme.of(context).accentColor,
                  //     content: Text(
                  //       'Deleting Failed!.',
                  //       style: TextStyle(color: Colors.white, fontSize: 15),
                  //     ));
                  // ScaffoldMessenger.of(scaffoldCTX).showSnackBar(snackBar);
                  print('Error Happened');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
