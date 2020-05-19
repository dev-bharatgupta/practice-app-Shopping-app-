import 'package:flutter/material.dart';
import 'package:meal_practice_app/providers/Products_provider.dart';
import 'package:meal_practice_app/screen/Produc_Detailed_Screen.dart';

class productgridview extends StatelessWidget {
//  final String title;
//  final String imageUrl;
//  final double price;
//  final String id;
//
//  productgridview({this.imageUrl, this.price, this.title, this.id});
  Product p;

  productgridview(this.p);

  @override
  Widget build(BuildContext context) {
    // final prod=Provider.of<Product_Items>(context,listen: false);
    {
      return Padding(
        padding: const EdgeInsets.all(3.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GridTile(

            child: Hero(
              tag: p.id,
              child: GestureDetector(
                onTap: () {

                  Navigator.of(context).pushNamed(ProductDetailedScreen.routename,
                      arguments: p.id);
                },
                child: FadeInImage(
                  fit: BoxFit.fill,
                  placeholder:
                      AssetImage("assets/images/product-placeholder.png"),
                  image: NetworkImage(
                    p.imageUrl,
                  ),
                ),
              ),
            ),
            header: Container(
              color: Colors.black54,
              child: Text(
                p.title,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
            footer: Container(
              color: Colors.black54,
              child: Text(
                "\$" + p.price.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      );
    }
  }
}
