import 'package:flutter/material.dart';
import 'package:meal_practice_app/widget/badge.dart';
import 'package:meal_practice_app/widget/productgridview.dart';
import 'package:meal_practice_app/widget/showdrawer.dart';
import '../providers/Products_provider.dart';
import 'package:provider/provider.dart';
import '../providers/authprovider.dart';

class ProductScreen extends StatefulWidget {
  static const routename = "/productscreen";

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  bool isfavourite = false;
  var init = true;
  var isloading = false;

  @override
  void didChangeDependencies() async {
    final auth = Provider.of<AuthProvider>(context);
    if (init) {
      setState(() {
        isloading = true;
      });
      try {
        await Provider.of<Product_Items>(context).fetchproducts(auth.idtoken,auth.userid,false);
      } catch (error) {
        showDialog(
            context: context,
            child: AlertDialog(
              content: Text("sorry no products can be loadid"),
            ));
        setState(() {
          isloading = false;
        });
      } finally {
        setState(() {
          isloading = false;
        });
      }
    }
    init = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Productitems = Provider.of<Product_Items>(context);
    return !isloading
        ? Scaffold(
            appBar: AppBar(
              title: !isfavourite ? Text("") : Text("Favourites"),
              actions: <Widget>[
                PopupMenuButton(
                  icon: Icon(Icons.arrow_drop_down),
                  onSelected: (selectedvalue) {
                    setState(() {
                      if (selectedvalue == 0)
                        isfavourite = false;
                      else
                        isfavourite = true;
                    });
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("All_products"),
                      value: 0,
                    ),
                    PopupMenuItem(
                      child: Text("Favourites"),
                      value: 1,
                    ),
                  ],
                ),
                Badge(),
              ],
            ),
            drawer: ShowDrawer(),
            body: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 2 / 2),
              itemBuilder: (context, index) => !isfavourite
                  ? productgridview(Productitems.productitems[index])
                  : productgridview(Productitems.favouriteitems[index]),
              itemCount: !isfavourite
                  ? Productitems.productitems.length
                  : Productitems.favouriteitems.length,
            ),
          )
        : Scaffold(
            appBar: AppBar(),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
