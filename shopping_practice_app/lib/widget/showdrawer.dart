import 'package:flutter/material.dart';
import 'package:meal_practice_app/screen/Proucts_screen.dart';
import 'package:meal_practice_app/screen/addproduct.dart';
import 'package:meal_practice_app/screen/orders_screen.dart';
import 'package:meal_practice_app/screen/viewproductandedit.dart';
import '../providers/authprovider.dart';
import 'package:provider/provider.dart';
import '../providers/Products_provider.dart';

class ShowDrawer extends StatefulWidget {

  @override
  _ShowDrawerState createState() => _ShowDrawerState();
}

class _ShowDrawerState extends State<ShowDrawer> {
  void nowthetime()
  {
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Drawer(
          child: Column(
            children: <Widget>[
              Text(
                "Shop",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30),
              ),
              GestureDetector(
                child: ListTile(
                  title: Text("all items"),
                  trailing: Icon(Icons.shop),
                  onTap: () {
                    Navigator.of(context).pushNamed(ProductScreen.routename);
                  },
                ),
              ),
              Divider(),
              GestureDetector(
                child: ListTile(
                  title: Text("orders"),
                  trailing: Icon(Icons.shopping_basket),
                  onTap: () {
                    Navigator.of(context).pushNamed(Order_Screen.routename);
                  },
                ),
              ),
              Divider(),
              GestureDetector(
                child: ListTile(
                  title: Text("add items"),
                  trailing: Icon(Icons.add),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(AddProductScreen.routename,
                      arguments: {"idx": -1, "edit": false});
                },
              ),
              Divider(),
              GestureDetector(
                child: ListTile(
                  title: Text("Edit/delete items"),
                  trailing: Icon(Icons.edit),
                ),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(Viewandeditproducts.routename);
                },
              ),
              Divider(),
              GestureDetector(
                child: ListTile(
                  title: Text("logout"),
                  trailing: Icon(Icons.broken_image),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                 Provider.of<AuthProvider>(context,listen: false).logout();
                },
              )
            ],
          ),

        ),

        width: 200,
      ),

    );
  }
}
