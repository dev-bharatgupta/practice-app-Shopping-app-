import 'package:flutter/material.dart';
import 'package:meal_practice_app/providers/Cart_Provider.dart';

class Orders extends StatefulWidget {
  final double amt;
  List<CartItem> cart = [];

  Orders({this.amt, this.cart});

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  bool ispressed = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(widget.amt.toString()),
//        subtitle: ispressed
//            ? SingleChildScrollView(
//                child: Column(
//                children: widget.cart.map((ct) {
//                  return Text(ct.title);
//                }).toList(),
//              ))
//            : null,
            trailing: IconButton(
              icon: !ispressed
                  ? Icon(Icons.expand_more)
                  : Icon(Icons.expand_less),
              onPressed: () {
                setState(() {
                  ispressed = !ispressed;
                });
              },
            ),
          ),
          if (ispressed)
            Container(
              child: Column(
                children: widget.cart.map((ct) {
                  return Text(ct.title);
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
