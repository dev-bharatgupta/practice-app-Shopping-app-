import 'package:flutter/material.dart';
import 'package:meal_practice_app/providers/Cart_Provider.dart';
import 'package:meal_practice_app/widget/favoutriteitem.dart';
import 'package:provider/provider.dart';
import '../providers/Products_provider.dart';

class ProductDetailedScreen extends StatelessWidget {
  static const routename = "/ProductDetailedScreen";

  @override
  Widget build(BuildContext context) {
    final detailed = Provider.of<Product_Items>(context, listen: false);
    final prodid = ModalRoute.of(context).settings.arguments as String;
    final cart = Provider.of<Cart>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: Builder(
        builder: (ctx) => SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Hero(
               
                tag: prodid,
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Image.network(
                    detailed.productbyid(prodid).imageUrl,
                    fit: BoxFit.fill,
                  ),
                  height: 200,
                  width: double.infinity,
                ),
              ),
              Text(
                "\$" + detailed.productbyid(prodid).price.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              Text(
                detailed.productbyid(prodid).description,
                softWrap: true,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Favouriteitem(prodid),
              SizedBox(
                height: 20,
              ),
////          FloatingActionButton(
//            child: Icon(Icons.add_shopping_cart),
//            onPressed: () {},
//          ),
              FlatButton(
                child: Text(
                  "Add to cart",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Scaffold.of(ctx).hideCurrentSnackBar();
                  final snack = SnackBar(
                    content: Text(
                      "Sdfsfs",
                      style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Colors.white,
                    duration: Duration(seconds: 1),
                    action: SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        cart.makequantitydecbyone(prodid);
                      },
                    ),
                  );
                  Scaffold.of(ctx).showSnackBar(snack);

                  return cart.additemincart(
                      prodid,
                      detailed.productbyid((prodid)).price,
                      detailed.productbyid(prodid).title);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
