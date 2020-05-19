import 'package:flutter/material.dart';
import 'package:meal_practice_app/providers/Cart_Provider.dart';
import 'package:meal_practice_app/providers/Orders_Providers.dart';
import 'package:meal_practice_app/providers/Products_provider.dart';
import 'package:meal_practice_app/providers/authprovider.dart';
import 'package:meal_practice_app/screen/Cart_Screen.dart';
import 'package:meal_practice_app/screen/Produc_Detailed_Screen.dart';
import 'package:meal_practice_app/screen/Proucts_screen.dart';
import 'package:meal_practice_app/screen/addproduct.dart';
import 'package:meal_practice_app/screen/aisehi.dart';
import 'package:meal_practice_app/screen/authscreen.dart';
import 'package:meal_practice_app/screen/orders_screen.dart';
import 'package:meal_practice_app/screen/viewproductandedit.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Product_Items()),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProvider.value(value: Orders_list()),
        ChangeNotifierProvider.value(value: AuthProvider()),
      ],
      child: MaterialApp(
        routes: {
          ProductScreen.routename: (context) => ProductScreen(),
          ProductDetailedScreen.routename: (context) => ProductDetailedScreen(),
          CartScreen.routename: (context) => CartScreen(),
          AddProductScreen.routename: (context) => AddProductScreen(),
          Order_Screen.routename: (context) => Order_Screen(),
          Viewandeditproducts.routename: (context) => Viewandeditproducts(),
        },
        home: Consumer<AuthProvider>(
          builder: (context, auth, _) =>
              auth.isauthenticate == true ? ProductScreen() : AuthScreen(),
        ),
        theme: ThemeData(
            primaryColor: Colors.deepOrangeAccent,
            accentColor: Colors.amberAccent,
            scaffoldBackgroundColor: Colors.amber),
      ),
    );
  }
}
