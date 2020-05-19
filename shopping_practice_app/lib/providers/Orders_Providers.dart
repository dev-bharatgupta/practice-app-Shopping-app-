import 'package:flutter/material.dart';
import 'package:meal_practice_app/providers/Cart_Provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Order {
  final String id;
  final DateTime datetime;
  final double amount;
  final List<CartItem> prod;

  Order({this.prod, this.amount, this.id, this.datetime});
}

class Orders_list with ChangeNotifier {
  Map<String, Order> _order_map = {};

  Map<String, Order> get order_map {
    return {..._order_map};
  }

  Future<void> fetchorder() async {
    Map<String, Order> temp = {};

    final url = "https://myshoppractice.firebaseio.com/orders.json";
    try {
      final response = await http.get(url);
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      decoded.forEach((orderid, value) {
        temp[orderid] = Order(
          id: orderid,
          amount: value["amount"],
          datetime: DateTime.now(),
          prod: (value["prod"] as List<dynamic>).map((tx) {
            return CartItem(title: tx["title"],
              amount: tx["amount"],
              quantity: tx["qunatity"],
              id: tx["id"],productid: tx["prodid"]);
          }).toList(),
        );
      });
      _order_map = temp;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addinorder(double amt, List<CartItem> prodc) async {
    final dt = DateTime.now();
    final url = "https://myshoppractice.firebaseio.com/orders.json";
    try {
      final response = await http.post(url,
          body: json.encode({
            "datetime": dt.toIso8601String(),
            "amount": amt,
            "prod": prodc.map((tx) {
              return {
                "qunaity": tx.quantity,
                "title": tx.title,
                "price": tx.amount,
                "id": tx.id,
                "prodid": tx.productid,
              };
            }).toList(),
          }));
      print(json.decode(response.body));
      _order_map[DateTime.now().toString()] =
          Order(id: "sd", datetime: DateTime.now(), amount: amt, prod: prodc);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
