import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/Products_provider.dart';
import '../providers/authprovider.dart';

class AddProductScreen extends StatefulWidget {
  static const routename = "/addproduct";

  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _amountfocal = FocusNode();
  final _imagefocal = FocusNode();
  var imagectr = TextEditingController();

  final key = GlobalKey<FormState>();
  var product = Product(
    id: null,
    title: "",
    description: "",
    imageUrl: "",
    price: 0.0,
  );

  @override
  void dispose() {
    _amountfocal.dispose();
    _imagefocal.dispose();
    super.dispose();
  }

  @override
  void initState() {
    imagectr.text="";
    _imagefocal.addListener(updateimg);

    super.initState();
  }

  void updateimg() {
    setState(() {});
  }

  bool iseditable = false;
  bool issaving = false;

  @override
  Widget build(BuildContext context) {
    //imagectr.text="";
    final arg =
    ModalRoute
        .of(context)
        .settings
        .arguments as Map<String, Object>;
    iseditable = arg["edit"];
    final editidx = arg["idx"];

    final prod = Provider.of<Product_Items>(context);
    final auth=Provider.of<AuthProvider>(context);
    if (iseditable)
      imagectr =
          TextEditingController(text: prod.productitems[editidx].imageUrl);

    // print(prod.productitems[editidx].imageUrl);
    // print(iseditable);
    return Scaffold(
      appBar: AppBar(
        title: !iseditable ? Text("ADD YOUR ITEM") : Text("Edit YOur item"),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: () async {
              key.currentState.save();
              // print(product.title);
              var valid = key.currentState.validate();
              if (!valid) return;
              if (iseditable)
                prod.updateproduct(product, editidx);
              else {
                setState(() {
                  issaving = true;
                });

                try {
                  await prod.addproduct(product,auth.userid,auth.idtoken);

                } catch (error) {
                  showDialog(context: context, child: AlertDialog(content: Text(
                      "not saved"),));
                  setState(() {
                    issaving = false;
                  });
                } finally {
                  setState(() {
                    issaving=false;
                  });
                }
              }
            },
          ),
        ],
      ),
      body: issaving
          ? Center(child: CircularProgressIndicator())
          : Form(
        key: key,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                textInputAction: TextInputAction.next,

                //key: key,
                decoration: InputDecoration(
                  labelText: "title",
                ),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_amountfocal);
                },
                onSaved: (value) {
                  product = Product(
                    title: value,
                    imageUrl: product.imageUrl,
                    description: product.description,
                    id: product.id,
                    price: product.price,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) return "plz enter title";

                  return null;
                },

                initialValue:
                iseditable ? prod.productitems[editidx].title : "",
              ),
              TextFormField(
                //key: key,
                textInputAction: TextInputAction.next,
                initialValue: iseditable
                    ? prod.productitems[editidx].price.toString()
                    : "",
                decoration: InputDecoration(labelText: "amount"),
                focusNode: _amountfocal,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).nextFocus();
                },
                onSaved: (value) {
                  product = Product(
                    title: product.title,
                    imageUrl: product.imageUrl,
                    description: product.description,
                    id: product.id,
                    price: double.tryParse(value),
                  );
                },
                validator: (value) {
                  if (value == null) return "plz entery amount";
                  if (double.tryParse(value) == null)
                    return "plz enter correct amount";
                  if (double.parse(value) <= 0)
                    return "amount can not be negative";
                  return null;
                },
              ),
              TextFormField(
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: "Discription"),
                initialValue: iseditable
                    ? prod.productitems[editidx].description
                    : "",
                maxLines: 3,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).nextFocus();
                },
                onSaved: (value) {
                  product = Product(
                    title: product.title,
                    imageUrl: product.imageUrl,
                    description: value,
                    id: product.id,
                    price: product.price,
                  );
                },
                validator: (value) {
                  if (value.isEmpty) return "plz enter desc";
                  if (value.length < 10) return "plz enter large desc";
                  return null;
                },
              ),
              Row(
                children: <Widget>[
                  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(right: 6, top: 6),
                    decoration:
                    BoxDecoration(border: Border.all(width: 2)),
                    child: imagectr.text.isEmpty
                        ? Text("no image")
                        : Image.network(imagectr.text),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: "imageUrl"),
                      textInputAction: TextInputAction.done,
                      onSaved: (value) {
                        product = Product(
                          title: product.title,
                          imageUrl: value,
                          description: product.description,
                          id: product.id,
                          price: product.price,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter an image URL.';
                        }
//                        if (!value.startsWith('http') &&
//                            !value.startsWith('https')) {
//                          return 'Please enter a valid URL.';
//                        }
//                        if (!value.endsWith('.png') &&
//                            !value.endsWith('.jpg') &&
//                            !value.endsWith('.jpeg')) {
//                          return 'Please enter a valid image URL.';
//                        }
                        return null;
                      },
                      onFieldSubmitted: (_) {
                        key.currentState.save();
                        print(product.title);
                        var valid = key.currentState.validate();
                        if (!valid) return;

                        prod.addproduct(product,auth.userid,auth.idtoken);
                      },
                      focusNode: _imagefocal,
                      controller: imagectr,
                    ),
                  ),

//                  if(iseditable) Expanded(
//                    child: TextFormField(
//                      initialValue:prod.productitems[editidx].imageUrl,
//
//                      decoration: InputDecoration(labelText: "imageUrl"),
//                      textInputAction: TextInputAction.done,
//                      onSaved: (value) {
//                        product = Product(
//                          title: product.title,
//                          imageUrl: value,
//                          description: product.description,
//                          id: product.id,
//                          price: product.price,
//                        );
//                      },
//                      validator: (value) {
//                        if (value.isEmpty) {
//                          return 'Please enter an image URL.';
//                        }
//                        if (!value.startsWith('http') &&
//                            !value.startsWith('https')) {
//                          return 'Please enter a valid URL.';
//                        }
//                        if (!value.endsWith('.png') &&
//                            !value.endsWith('.jpg') &&
//                            !value.endsWith('.jpeg')) {
//                          return 'Please enter a valid image URL.';
//                        }
//                        return null;
//                      },
//                      onFieldSubmitted: (_) {
//                        key.currentState.save();
//                        print(product.title);
//                        var valid = key.currentState.validate();
//                        if (!valid) return;
//
//                        prod.addproduct(product);
//                      },
//                      focusNode: _imagefocal,
//                      controller: imagectr,
//                    ),
//                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
