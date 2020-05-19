import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isfavourite;

  Product(
      {this.id,
      this.title,
      this.price,
      this.imageUrl,
      this.description,
      this.isfavourite = false});
}

class Product_Items with ChangeNotifier {
  List<Product> _Productitems = [
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];

  Product productbyid(String id) {
    return _Productitems.firstWhere((prod) => prod.id == id);
  }

  Future<void> makeitemfavandunfav(
      Product product, String userid, String tokenid) async {
    final url =
        'https://myshoppractice.firebaseio.com/favandunfavproducts/$userid/${product.id}.json?auth=$tokenid';

    try {
      final response = await http.put(url,
          body: json.encode({"isfavourite": !product.isfavourite}));
      product.isfavourite = !product.isfavourite;
    } catch (error) {
      throw error;
    }
  }

  List<Product> get favouriteitems {
    return _Productitems.where((prod) {
      return prod.isfavourite;
    }).toList();
  }

  Future<void> addproduct(
      Product product, String userid, String tokenid) async {
    final url =
        "https://myshoppractice.firebaseio.com/products.json?auth=$tokenid";

    try {
      final response = await http.post(url,
          body: json.encode({
            "title": product.title,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "description": product.description,

            "userid": userid,
          }));
      //print("agaya");
      _Productitems.add(
        Product(
          title: product.title,
          imageUrl: product.imageUrl,
          price: product.price,
          description: product.description,
          id: json.decode(response.body)["name"],
        ),
      );
      print("saved");
      notifyListeners();
    } catch (error) {
      print("error");
      throw error;
    }

    print(_Productitems[0].id);
    // print("saved");
  }

  Future<void> fetchproducts(
      String idtoken, String userid, bool ownproduct) async {
    var url =
        "https://myshoppractice.firebaseio.com/products.json?auth=$idtoken";
    if (ownproduct)
      url =
          'https://myshoppractice.firebaseio.com/products.json?auth=$idtoken&orderBy="userid"&equalTo="$userid"';
    try {
      final response = await http.get(url);
      final List<Product> temp = [];
      final mp = json.decode(response.body) as Map<String, Object>;
      mp.forEach((prodid, prods)  {


        temp.add(
          Product(
              id: prodid,
              price: (prods as Map)["price"],
              description: (prods as Map)["description"],
              isfavourite: false,
              title: (prods as Map)["title"],
              imageUrl: (prods as Map)["imageUrl"]),
        );
      });

      _Productitems = temp;

      if (ownproduct) {
        print(userid);
        print(json.decode(response.body));
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
    try{
      final url =
          'https://myshoppractice.firebaseio.com/favandunfavproducts/$userid.json?auth=$idtoken';
    final response=await http.get(url);
    print(response.statusCode);

      Map<String,Object> tempmap={};

    tempmap = json.decode(response.body)  ;
    productitems.forEach((prod){
      if(tempmap['${prod.id}']!=null)
        {
          prod.isfavourite=(tempmap as Map )['${prod.id}']['isfavourite'];
        }
    });
    if(tempmap==null)
      return;
     }catch(error)
    {
      //print(error);
      //throw error;
    }
  }

  List<Product> get productitems {
    return [..._Productitems];
  }

  void updateproduct(Product product, int idx) {
    _Productitems.removeAt(idx);
    _Productitems.insert(idx, product);
    notifyListeners();
  }

  Future<void> delteproduct(int idx, String tokenid) async {
    final temp = _Productitems[idx];

    _Productitems.removeAt(idx);

    final url =
        "https://myshoppractice.firebaseio.com/products/${temp.id}.json?auth=$tokenid";

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _Productitems.insert(idx, temp);
      notifyListeners();
      throw "deleted";
    }
    notifyListeners();
  }
}
