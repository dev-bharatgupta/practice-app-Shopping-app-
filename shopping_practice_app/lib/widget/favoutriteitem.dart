import 'package:flutter/material.dart';
import 'package:meal_practice_app/providers/authprovider.dart';
import 'package:provider/provider.dart';
import '../providers/Products_provider.dart';
import '../providers/Products_provider.dart';
import 'package:http/http.dart';
import 'dart:convert';

class Favouriteitem extends StatefulWidget {
  final prodid;

  Favouriteitem(this.prodid);

  @override
  _FavouriteitemState createState() => _FavouriteitemState();
}

class _FavouriteitemState extends State<Favouriteitem> {
  bool isfav = false;

  @override
  Widget build(BuildContext context) {
    final detailed = Provider.of<Product_Items>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final prod = detailed.productbyid(widget.prodid);
    return FloatingActionButton(
      child: !prod.isfavourite
          ? Icon(Icons.favorite_border)
          : Icon(Icons.favorite),
      onPressed: () async {
        try {
          final response = await detailed.makeitemfavandunfav(
              detailed.productbyid(widget.prodid), auth.userid,auth.idtoken);
          setState(() {

          });

        } catch (error) {



          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    content: Text("oops"),
                  ));
        }
      },
    );
  }
}
