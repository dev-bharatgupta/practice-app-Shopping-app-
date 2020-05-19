import 'package:meal_practice_app/screen/Cart_Screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/Products_provider.dart';
import '../providers/Cart_Provider.dart';

class Badge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final x = Provider.of<Cart>(context);
    final y = x.cartlen;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Stack(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
            onPressed: (){
              Navigator.of(context).pushNamed(CartScreen.routename,);
            },
          ),
          Positioned(
            right: 1,
            top: 2,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                y.toString(),
                style: TextStyle(color: Colors.black),
              ),
              radius: 10,
            ),
          )
        ],
      ),
    );
  }
}
