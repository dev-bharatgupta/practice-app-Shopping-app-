import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Cart_Provider.dart';
import '../providers/Orders_Providers.dart';

class CartScreen extends StatelessWidget {
  static const routename = "/CartScreen";
  bool t = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("\$" + cart.gettotalamt.toString()),
      ),
      body: ListView(
        children: cart.cartmap.values.toList().map((item) {
          return Dismissible(
            onDismissed: (direction) {
              cart.removeitemfromcart(item.productid);
            },
            confirmDismiss: (direction) {
              return showDialog(
                context: context,
                child: AlertDialog(
                  content: Text("Do you want to remove it"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("no"),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text("yes"),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    )
                  ],
                ),
              );
            },
            direction: DismissDirection.endToStart,
            key: ValueKey(key),
            background: Container(
              margin: EdgeInsets.symmetric(vertical: 5),
              padding: EdgeInsets.only(right: 20),
              color: Colors.white,
              child: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              alignment: Alignment.centerRight,
            ),
            child: Card(
              color: Theme.of(context).accentColor,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.deepOrangeAccent,
                  child: Text("x" + item.quantity.toString()),
                ),
                trailing: Text("\$" + (item.quantity * item.amount).toString()),
                title: Text(
                  item.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        }).toList(),
      ),
      floatingActionButton: NewWidget(cart: cart),
    );
  }
}

class NewWidget extends StatefulWidget {
  const NewWidget({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _NewWidgetState createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return isloading
        ? CircularProgressIndicator()
        : FloatingActionButton(
            hoverColor: Colors.redAccent,
            backgroundColor: Colors.deepOrangeAccent,
            onPressed: () async {
              setState(() {
                isloading = true;
              });
              try {
                await Provider.of<Orders_list>(context, listen: false)
                    .addinorder(widget.cart.gettotalamt,
                        widget.cart.cartmap.values.toList());
                widget.cart.makecartempty();
                setState(() {
                  isloading = false;
                });
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("yes"),
                ));
              } catch (error) {
                setState(() {
                  isloading = false;
                });
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("oops"),
                ));
              }
              },
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          );
  }
}
