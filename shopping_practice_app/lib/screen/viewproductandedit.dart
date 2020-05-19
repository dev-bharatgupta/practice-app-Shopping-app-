import 'package:flutter/material.dart';
import 'package:meal_practice_app/screen/addproduct.dart';
import 'package:provider/provider.dart';
import '../providers/Products_provider.dart';
import '../providers/authprovider.dart';

class Viewandeditproducts extends StatelessWidget {
  static const routename = "/Viewandeditproducts";

  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<Product_Items>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("here is ur products"),
      ),
      body: FutureBuilder(
        future: prod.fetchproducts(auth.idtoken, auth.userid, true),
        builder: (context, snapshot) => (snapshot.connectionState ==
                ConnectionState.waiting)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () {
                  return prod.fetchproducts(auth.idtoken, auth.userid, true);
                },
                child: Consumer<Product_Items>(
                  builder: (context, prods, _) => ListView.builder(
                    itemBuilder: (context, idx) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepOrangeAccent,
                          child: Text(idx.toString()),
                        ),
                        title: Text(prods.productitems[idx].title),
                        subtitle:
                            Text(prods.productitems[idx].price.toString()),
                        trailing: Container(
                          width: 100,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                ),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      AddProductScreen.routename,
                                      arguments: {"idx": idx, "edit": true});
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  return showDialog(
                                      context: context,
                                      child: AlertDialog(
                                        title: Text("are u sure"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("yes"),
                                            onPressed: () async {
                                              try {
                                                Navigator.of(context).pop();
                                                await prods.delteproduct(idx,auth.idtoken);
                                                Scaffold.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text("done"),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ));
                                              } catch (error) {
                                                print(error);
                                                Navigator.of(context).pop();
                                                Scaffold.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text("sorry"),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ));
                                              }
                                            },
                                          ),
                                          FlatButton(
                                            child: Text("no"),
                                            onPressed: () {
                                              // prods.delteproduct(idx);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ));
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: prods.productitems.length,
                  ),
                ),
              ),
      ),
    );
  }
}
