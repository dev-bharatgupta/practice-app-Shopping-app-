import 'package:flutter/material.dart';

class CartItem {
  int quantity;
  final String id;
  final String productid;
  final double amount;
  final String title;
  CartItem({this.id, this.amount, this.quantity, this.productid,this.title});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartmap={};

  Map<String, CartItem> get cartmap {
    return {..._cartmap};
  }

  void additemincart(String prodid, double amt,String title) {
    if (!_cartmap.containsKey(prodid)) {
      _cartmap.putIfAbsent(
        prodid,
        () => CartItem(
          id: DateTime.now().toString(),
          amount: amt,
          quantity: 1,
          productid: prodid,
          title: title,
        ),
      );
    }

    else
      _cartmap[prodid].quantity++;
    notifyListeners();
  }
  double get gettotalamt
  {
     double amt=0.0;
       if(_cartmap.isEmpty)
         return 0;
       else {
         _cartmap.forEach((key, tx) {
           amt = tx.quantity * tx.amount + amt;
         });
         return amt;
       }

  }
  int get cartlen
  {
    return _cartmap.length;
  }

  void removeitemfromcart(String prodid)
  {
    _cartmap.remove(prodid);
    notifyListeners();
  }

  void makequantitydecbyone(String prodid)
  {
    _cartmap[prodid].quantity--;
    if( _cartmap[prodid].quantity==0)
      {
        _cartmap.remove(prodid);
      }
    notifyListeners();
  }
  void makecartempty()
  {
    _cartmap.clear();
    notifyListeners();

  }


}
